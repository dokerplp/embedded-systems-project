package itmo.zavar.car;

import com.fazecast.jSerialComm.SerialPort;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Scanner;

public class Launcher {
    public static void main(String[] args) throws InterruptedException {
        SerialPort arduino = SerialPort.getCommPort("COM4");
        arduino.setBaudRate(115200);
        arduino.openPort();
        Thread.sleep(5000);
        System.out.println("ready");
        Scanner scanner = new Scanner(arduino.getInputStream());
        PrintWriter writer = new PrintWriter(arduino.getOutputStream());
        Scanner console = new Scanner(System.in);

        while (true) {
            if(console.hasNext()) {
                arduino.setComPortTimeouts(SerialPort.TIMEOUT_SCANNER, 0, 0);
                writer.print(console.next() + "s");
                writer.flush();
            }
            System.out.println(scanner.next());
            System.out.println();
        }

    }
}
