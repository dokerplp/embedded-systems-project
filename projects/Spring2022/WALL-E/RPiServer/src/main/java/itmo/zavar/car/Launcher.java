package itmo.zavar.car;

import com.fazecast.jSerialComm.SerialPort;
import itmo.zavar.car.server.ArduinoServer;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Scanner;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

public class Launcher {
    public static void main(String[] args) throws InterruptedException, IOException {
//        SerialPort arduino = SerialPort.getCommPort("COM4");
//        arduino.setBaudRate(115200);
//        arduino.openPort();
//        Thread.sleep(5000);
//        System.out.println("ready");
//        Scanner scanner = new Scanner(arduino.getInputStream());
//        PrintWriter writer = new PrintWriter(arduino.getOutputStream());
//        Scanner console = new Scanner(System.in);
//
//        while (true) {
//            if(console.hasNext()) {
//                arduino.setComPortTimeouts(SerialPort.TIMEOUT_SCANNER, 0, 0);
//                writer.print(console.next() + "s");
//                writer.flush();
//            }
//            System.out.println(scanner.next());
//            System.out.println();
//        }
        ArduinoServer arduinoServer = new ArduinoServer("COM4", 115200, 25565);
        Executor executor = Executors.newSingleThreadExecutor();
        executor.execute(arduinoServer);
    }
}
