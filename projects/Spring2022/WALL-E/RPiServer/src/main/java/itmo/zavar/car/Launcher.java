package itmo.zavar.car;

import itmo.zavar.car.server.ArduinoServer;

import java.io.IOException;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

public class Launcher {
    public static void main(String[] args) throws InterruptedException, IOException {
        ArduinoServer arduinoServer = new ArduinoServer(args[0], 115200, 25565);
        Executor executor = Executors.newSingleThreadExecutor();
        executor.execute(arduinoServer);
    }
}