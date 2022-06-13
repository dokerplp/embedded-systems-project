package itmo.zavar.car;

import itmo.zavar.car.gpio.server.GPIOServer;

import java.io.IOException;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

/**
 * Main class
 * @version 1.1
 * @author Zavar30
 */
public class Launcher {
    public static void main(String[] args) throws IOException {
        GPIOServer gpioServer = new GPIOServer(25565, 13, 12, 0x08);
        Executor executor = Executors.newSingleThreadExecutor();
        executor.execute(gpioServer);
    }
}
