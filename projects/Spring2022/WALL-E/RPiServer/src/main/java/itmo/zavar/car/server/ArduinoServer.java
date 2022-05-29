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
                    logger.info("Waiting...");
                    Thread.sleep(5000);
                    arduinoScanner = new Scanner(arduino.getInputStream());
                    arduinoWriter = new PrintWriter(arduino.getOutputStream());
                    logger.info("Connected");
                }
                logger.info("Waiting for client...");
                client = serverSocket.accept();
                BufferedReader clientReader = new BufferedReader(new InputStreamReader(client.getInputStream()));
                BufferedWriter clientWriter = new BufferedWriter(new OutputStreamWriter(client.getOutputStream()));
                logger.info("Accepted connection");

                String input;
                String fromArduino = "0-0";
                String prevFromArduino = fromArduino;

                while(!client.isClosed()) {
                    try {
                        if((input = clientReader.readLine()) != null) {
                            logger.info("Got from client: " + input);
                            setCarValues(input);
                        } else {
                            throw new IOException("Connection reset");
                        }


                        if(arduinoScanner.hasNext("\\d+-\\d+")) {
                            fromArduino = arduinoScanner.next();
                            logger.info("Got from arduino: " + fromArduino);
                            clientWriter.write(fromArduino);
                        } else {
                            logger.info("Prev got from arduino: " + prevFromArduino);
                            clientWriter.write(prevFromArduino);
                        }
                        clientWriter.newLine();
                        clientWriter.flush();
                        prevFromArduino = fromArduino;

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
        arduino.setComPortTimeouts(SerialPort.TIMEOUT_SCANNER, 1, 1);
        arduinoWriter.print(input + TERMINATOR);
        arduinoWriter.flush();
    }

    public SerialPort getArduino() {
        return arduino;
    }

    public int getServerPort() {
        return serverPort;
    }
}
