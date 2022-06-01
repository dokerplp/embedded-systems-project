package itmo.zavar.car;

import com.pi4j.Pi4J;
import com.pi4j.context.Context;
import com.pi4j.library.pigpio.PiGpio;
import com.pi4j.plugin.pigpio.provider.gpio.digital.PiGpioDigitalInputProvider;
import com.pi4j.plugin.pigpio.provider.gpio.digital.PiGpioDigitalOutputProvider;
import com.pi4j.plugin.pigpio.provider.i2c.PiGpioI2CProvider;
import com.pi4j.plugin.pigpio.provider.pwm.PiGpioPwmProvider;
import com.pi4j.plugin.pigpio.provider.serial.PiGpioSerialProvider;
import com.pi4j.plugin.pigpio.provider.spi.PiGpioSpiProvider;
import com.pi4j.plugin.raspberrypi.platform.RaspberryPiPlatform;
import itmo.zavar.car.arduino.server.ArduinoServer;
import itmo.zavar.car.gpio.component.ServoMotorComponent;
import itmo.zavar.car.gpio.server.GPIOServer;

import java.io.IOException;
import java.util.Scanner;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

public class Launcher {
    public static void main(String[] args) throws InterruptedException, IOException {
        //ArduinoServer arduinoServer = new ArduinoServer(args[0], 115200, 25565);
        GPIOServer gpioServer = new GPIOServer(25565, 13, 12);
        Executor executor = Executors.newSingleThreadExecutor();
        executor.execute(gpioServer);

//        ServoMotorComponent esc = new ServoMotorComponent(buildNewContext(), 13);
//        Scanner scanner = new Scanner(System.in);
//        while (scanner.hasNextLine()) {
//            esc.writeMicroseconds(scanner.nextInt());
//        }
    }

    private static Context buildNewContext() {
        PiGpio piGpio = PiGpio.newNativeInstance();
        return Pi4J.newContextBuilder()
                .noAutoDetect()
                .add(new RaspberryPiPlatform())
                .add(
                        PiGpioDigitalInputProvider.newInstance(piGpio),
                        PiGpioDigitalOutputProvider.newInstance(piGpio),
                        PiGpioPwmProvider.newInstance(piGpio),
                        PiGpioI2CProvider.newInstance(piGpio),
                        PiGpioSerialProvider.newInstance(piGpio),
                        PiGpioSpiProvider.newInstance(piGpio)
                )
                .build();
    }

}
