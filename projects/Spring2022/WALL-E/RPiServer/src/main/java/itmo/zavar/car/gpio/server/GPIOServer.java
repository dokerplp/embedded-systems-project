package itmo.zavar.car.gpio.server;

import com.fazecast.jSerialComm.SerialPort;
import itmo.zavar.car.arduino.server.ArduinoServer;
import itmo.zavar.car.gpio.controller.CarController;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.NoSuchElementException;
import java.util.concurrent.Executor;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class GPIOServer implements Runnable {
    private final Logger logger = LogManager.getLogger(GPIOServer.class.getName());
    private final int serverPort;
    private final ServerSocket serverSocket;

    private Socket client;
    private final CarController carController;

    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    public GPIOServer(int serverPort, int escPin, int steeringPin) throws IOException {
        this.serverPort = serverPort;
        serverSocket = new ServerSocket(serverPort);
        carController = new CarController(escPin, steeringPin);
    }

    @Override
    public void run() {
        executor.execute(carController);
        while (!Thread.currentThread().isInterrupted()) {
            try {
                logger.info("Waiting for client...");
                client = serverSocket.accept();
                BufferedReader clientReader = new BufferedReader(new InputStreamReader(client.getInputStream()));
                BufferedWriter clientWriter = new BufferedWriter(new OutputStreamWriter(client.getOutputStream()));
                logger.info("Accepted connection");

                String input;
                String prevInput = "";
                String fromGpio = "0-0";

                while (!client.isClosed()) {
                    try {
                        if ((input = clientReader.readLine()) != null) {
                            logger.info("Got from client: " + input);
                            String[] values = input.split(":");
                            carController.setInputSpeed(Float.parseFloat(values[0]));
                            carController.setInputWheelAngle(Float.parseFloat(values[1]));
                        } else {
                            throw new IOException("Connection reset");
                        }

                        logger.info("Got from gpio: " + fromGpio);
                        clientWriter.write(fromGpio);
                        clientWriter.newLine();
                        clientWriter.flush();
                        Thread.sleep(25);
                    } catch (IOException | InterruptedException e) {
                        client.close();
                        carController.resetAll();
                        logger.error(e.getMessage());
                        break;
                    }
                }
            } catch (IOException e) {
                logger.error("Can't connect to the client");
                logger.error(e.getMessage());
                carController.resetAll();
            }
        }
        executor.shutdown();
        logger.info("Server was interrupted");
    }

    public int getServerPort() {
        return serverPort;
    }
}
