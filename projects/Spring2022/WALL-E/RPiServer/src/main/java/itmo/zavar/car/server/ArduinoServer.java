package itmo.zavar.car.server;

import com.fazecast.jSerialComm.SerialPort;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.NoSuchElementException;
import java.util.Scanner;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public final class ArduinoServer implements Runnable {

    private final Logger logger = LogManager.getLogger(ArduinoServer.class.getName());

    private final int serverPort;
    private final ServerSocket serverSocket;
    private Socket client;
    private int timeout = 10000;

    private final SerialPort arduino;
    private Scanner arduinoScanner;
    private PrintWriter arduinoWriter;

    public ArduinoServer(String comPortName, int baudRate, int serverPort) throws IOException {
        this.serverPort = serverPort;
        arduino = SerialPort.getCommPort(comPortName);
        arduino.setBaudRate(baudRate);
        serverSocket = new ServerSocket(serverPort);
    }

    @Override
    public void run() {
        while(!Thread.currentThread().isInterrupted()) {
            try {
                if(!arduino.isOpen()) {
                    logger.info("Connecting to arduino...");
                    while(!arduino.openPort());
                    Thread.sleep(5000);
                    arduinoScanner = new Scanner(arduino.getInputStream());
                    arduinoWriter = new PrintWriter(arduino.getOutputStream());
                    logger.info("Connected");
                }
                logger.info("Waiting for client...");
                client = serverSocket.accept();
                BufferedReader clientReader = new BufferedReader(new InputStreamReader(client.getInputStream()));
                BufferedWriter clientWriter = new BufferedWriter(new OutputStreamWriter(client.getOutputStream()));
                //client.setSoTimeout(timeout);
                logger.info("Accepted connection");

                String input;

                while(true) {
                    try {
                        if((input = clientReader.readLine()) != null) {
                            logger.info("Got from client: " + input);
                            setCarValues(input);
                        }

                        String fromArduino = arduinoScanner.next();
                        logger.info("Got from arduino: " + fromArduino);
                        clientWriter.write(fromArduino);
                        clientWriter.newLine();//only for Java client, should be removed
                        clientWriter.flush();

                    } catch (IOException e) {
                        client.close();
                        setCarValues("0:0");
                        logger.error(e.getMessage());
                        break;
                    } catch (NoSuchElementException e) {
                        client.close();
                        arduino.closePort();
                        logger.error("COM port is closed");
                        logger.error(e);
                        break;
                    }
                }
            } catch (IOException | InterruptedException e) {
                logger.error("Can't connect to the client");
                logger.error(e.getMessage());
                setCarValues("0:0");
            }
        }
        try {
            setCarValues("0:0");
            client.close();
            serverSocket.close();
            arduino.closePort();
        } catch (IOException e) {
            logger.error(e.getMessage());
        }
        logger.info("Server was interrupted");
    }

    private void setCarValues(String input) {
        String TERMINATOR = "s";
        arduino.setComPortTimeouts(SerialPort.TIMEOUT_SCANNER, 0, 0);
        arduinoWriter.print(input + TERMINATOR);
        arduinoWriter.flush();
    }

    public SerialPort getArduino() {
        return arduino;
    }

    public int getTimeout() {
        return timeout;
    }

    public void setTimeout(int timeout) {
        this.timeout = timeout;
    }

    public int getServerPort() {
        return serverPort;
    }
}
