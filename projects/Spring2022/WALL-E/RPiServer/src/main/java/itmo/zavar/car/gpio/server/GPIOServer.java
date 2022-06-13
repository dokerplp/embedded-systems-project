package itmo.zavar.car.gpio.server;

import itmo.zavar.car.gpio.controller.CarController;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Server implementation for TCP client and for sending data to GPIO pins. Sends battery values (format: 'v1-v2') in
 * range [0; 100] and receives speed (s) and steering angle (a) (format: 's-a') in range [-1; 1] where 0 is
 * neutral position (or brake).
 */
public final class GPIOServer implements Runnable {
    private final Logger logger = LogManager.getLogger(GPIOServer.class.getName());
    private final int serverPort;
    private final ServerSocket serverSocket;

    private Socket client;
    private final CarController carController;

    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    /**
     * Server setup
     *
     * @param serverPort Port for listening
     * @param escPin GPIO pin for ESC
     * @param steeringPin GPIO pin for steering servo
     * @param batteryAddress I2C address for arduino (sends voltage sensors values)
     */
    public GPIOServer(int serverPort, int escPin, int steeringPin, int batteryAddress) throws IOException {
        this.serverPort = serverPort;
        serverSocket = new ServerSocket(serverPort);
        carController = new CarController(escPin, steeringPin, batteryAddress);
    }

    @Override
    public void run() {
        executor.execute(carController);
        while (!Thread.currentThread().isInterrupted()) {
            try {
                logger.info("Waiting for client...");
                //client accepting
                client = serverSocket.accept();
                client.setSoTimeout(3000);
                BufferedReader clientReader = new BufferedReader(new InputStreamReader(client.getInputStream()));
                BufferedWriter clientWriter = new BufferedWriter(new OutputStreamWriter(client.getOutputStream()));
                logger.info("Accepted connection");

                String input;
                String fromGpio;

                while (!client.isClosed()) {
                    try {
                        //getting speed and angle from client and writing them to gpio
                        if ((input = clientReader.readLine()) != null) {
                            logger.info("Got from client: " + input);
                            String[] values = input.split(":");
                            carController.setInputSpeed(Float.parseFloat(values[0]));
                            carController.setInputWheelAngle(Float.parseFloat(values[1]));
                        } else {
                            throw new IOException("Connection reset");
                        }
                        //getting batteries values and sends them to client
                        fromGpio = carController.getBatteryValue();
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
