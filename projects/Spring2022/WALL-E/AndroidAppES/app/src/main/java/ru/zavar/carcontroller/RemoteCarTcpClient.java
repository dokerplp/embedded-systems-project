package ru.zavar.carcontroller;

import android.util.Log;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.InetSocketAddress;
import java.net.NoRouteToHostException;
import java.net.Socket;
import java.net.SocketAddress;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public final class RemoteCarTcpClient {

    private Socket socket;
    private BufferedReader clientReader;
    private BufferedWriter clientWriter;

    private volatile int gas = 0;
    private volatile double rotation = 0;
    private volatile int engineBatteryValue = 0;
    private volatile int rpiBatteryValue = 0;
    private TransmissionMode transmissionMode = TransmissionMode.PARK;

    private final String host;
    private final int port;

    private final ExecutorService executor = Executors.newSingleThreadExecutor();
    private StopListener stopListener;

    private BatteryValueChangedListener engineBatteryListener;
    private BatteryValueChangedListener rpiBatteryListener;

    public RemoteCarTcpClient(String host, int port) {
        this.host = host;
        this.port = port;
    }

    public void start() {
        executor.execute(() -> {
            try {
                socket = new Socket();
                SocketAddress socketAddress = new InetSocketAddress(host, port);
                socket.connect(socketAddress, 3000);
                socket.setSoTimeout(2000);
                clientReader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                clientWriter = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));

                String input;
                int prevEngineBatteryValue = -1;
                int prevRpiBatteryValue = -1;
                while (!socket.isClosed() && !Thread.currentThread().isInterrupted() && socket.isConnected()) {
                    clientWriter.write((double) gas / 100 + ":" + rotation);
                    clientWriter.newLine();
                    clientWriter.flush();
                    if ((input = clientReader.readLine()) != null) {
                        try {
                            String[] values = input.split("-");
                            engineBatteryValue = Integer.parseInt(values[0]);
                            if (engineBatteryListener != null && prevEngineBatteryValue != engineBatteryValue)
                                engineBatteryListener.onBatteryValueChanged(engineBatteryValue);

                            rpiBatteryValue = Integer.parseInt(values[1]);
                            if (rpiBatteryListener != null && prevRpiBatteryValue != rpiBatteryValue)
                                rpiBatteryListener.onBatteryValueChanged(rpiBatteryValue);
                        } catch (ArrayIndexOutOfBoundsException | NumberFormatException ignored) {

                        } finally {
                            prevEngineBatteryValue = engineBatteryValue;
                            prevRpiBatteryValue = rpiBatteryValue;
                        }
                    }
                }
            } catch (Exception ignored) {

            } finally {
                stop();
            }
        });
    }

    public void stop(String message) {
        try {
            if(socket != null && socket.isConnected()) {
                socket.shutdownInput();
                socket.shutdownOutput();
                socket.close();
            }
            executor.shutdownNow();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            stopListener.onStop(message);
        }
    }

    public void stop() {
        stop("");
    }

    public void setGas(int gas) {
        if (transmissionMode == TransmissionMode.REVERSE)
            gas = -gas;
        else if (transmissionMode == TransmissionMode.PARK)
            gas = 0;
        this.gas = gas;
    }

    public void setRotation(int rotation) {
        this.rotation = mapf(rotation, 0, 100, -1.0, 1.0);
    }

    private double mapf(double val, double in_min, double in_max, double out_min, double out_max) {
        return (val - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
    }

    public void setTransmissionMode(TransmissionMode transmissionMode) {
        this.transmissionMode = transmissionMode;
    }

    public TransmissionMode getTransmissionMode() {
        return transmissionMode;
    }

    public void nextTransmissionMode() {
        if (transmissionMode.equals(TransmissionMode.PARK))
            transmissionMode = TransmissionMode.DRIVE;
        else if (transmissionMode.equals(TransmissionMode.DRIVE))
            transmissionMode = TransmissionMode.REVERSE;
        else if (transmissionMode.equals(TransmissionMode.REVERSE))
            transmissionMode = TransmissionMode.PARK;
    }

    public void previousTransmissionMode() {
        if (transmissionMode.equals(TransmissionMode.PARK))
            transmissionMode = TransmissionMode.REVERSE;
        else if (transmissionMode.equals(TransmissionMode.REVERSE))
            transmissionMode = TransmissionMode.DRIVE;
        else if (transmissionMode.equals(TransmissionMode.DRIVE))
            transmissionMode = TransmissionMode.PARK;
    }

    public int getEngineBatteryValue() {
        return engineBatteryValue;
    }

    public int getRpiBatteryValue() {
        return rpiBatteryValue;
    }

    public void setEngineBatteryListener(BatteryValueChangedListener listener) {
        this.engineBatteryListener = listener;
    }

    public void setRpiBatteryListener(BatteryValueChangedListener listener) {
        this.rpiBatteryListener = listener;
    }

    public void setStopListener(StopListener stopListener) {
        this.stopListener = stopListener;
    }
}

@FunctionalInterface
interface BatteryValueChangedListener {
    void onBatteryValueChanged(int value);
}

@FunctionalInterface
interface StopListener {
    void onStop(String message);
}
