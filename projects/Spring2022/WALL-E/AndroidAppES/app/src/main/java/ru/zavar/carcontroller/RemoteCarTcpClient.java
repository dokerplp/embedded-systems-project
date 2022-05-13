package ru.zavar.carcontroller;

import android.util.Log;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.Socket;

public class RemoteCarTcpClient {

    private Socket socket;
    private BufferedReader clientReader;
    private BufferedWriter clientWriter;

    private volatile int gas = 0;
    private volatile double rotation = 0;
    private TransmissionMode transmissionMode = TransmissionMode.PARK;

    private final String host;
    private final int port;

    public RemoteCarTcpClient(String host, int port) {
        this.host = host;
        this.port = port;
    }

    public void start() {
        new Thread(() -> {
            try {
                socket = new Socket(host, port);
                clientReader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                clientWriter = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));

                while (!socket.isClosed()) {
                    clientWriter.write((double) gas / 100 + ":" + rotation);
                    clientWriter.newLine();
                    clientWriter.flush();
                    String input;
                    if ((input = clientReader.readLine()) != null) {
                        Log.i("testTag", input);
                    }
                }

            } catch (IOException e) {
                e.printStackTrace();
            }
        }).start();
    }

    public void stop() {
        try {
            socket.shutdownInput();
            socket.shutdownOutput();
            socket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void setGas(int gas) {
        if(transmissionMode == TransmissionMode.REVERSE)
            gas = -gas;
        else if(transmissionMode == TransmissionMode.PARK)
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
        if(transmissionMode.equals(TransmissionMode.PARK))
            transmissionMode = TransmissionMode.DRIVE;
        else if(transmissionMode.equals(TransmissionMode.DRIVE))
            transmissionMode = TransmissionMode.REVERSE;
        else if(transmissionMode.equals(TransmissionMode.REVERSE))
            transmissionMode = TransmissionMode.PARK;
    }

    public void previousTransmissionMode() {
        if(transmissionMode.equals(TransmissionMode.PARK))
            transmissionMode = TransmissionMode.REVERSE;
        else if(transmissionMode.equals(TransmissionMode.REVERSE))
            transmissionMode = TransmissionMode.DRIVE;
        else if(transmissionMode.equals(TransmissionMode.DRIVE))
            transmissionMode = TransmissionMode.PARK;
    }
}
