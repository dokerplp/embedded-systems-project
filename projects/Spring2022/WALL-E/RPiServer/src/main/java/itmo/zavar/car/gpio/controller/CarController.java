package itmo.zavar.car.gpio.controller;

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
import itmo.zavar.car.gpio.component.ServoMotorComponent;
import itmo.zavar.car.gpio.server.GPIOServer;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public final class CarController implements Runnable {
    private final int STOP = 1550;
    private final static int FORWARD_BRAKE = 1300;
    private final static int FORWARD_MAX = 1850;
    private final static int FORWARD_MIN = 1610;
    private final static int BACKWARD_BRAKE = 1590;
    private final static int BACKWARD_MAX = 1490;
    private final static int BACKWARD_MIN = 1520;
    private final static int ROTATE_RIGHT_MAX = 95;
    private final static int ROTATE_ZERO = 125;
    private final static int ROTATE_LEFT_MAX = 150;

    public final ServoMotorComponent esc;
    public final ServoMotorComponent steering;

    private volatile float inputSpeed = 0.0F;
    private volatile float inputAngle = 0.0F;
    private float prevSpeed = 0.0F;
    private float prevAngle = 0.0F;

    public CarController(int escPin, int steeringPin) {
        Context context = buildNewContext();
        esc = new ServoMotorComponent(context, escPin);
        esc.writeMicroseconds(STOP);
        steering = new ServoMotorComponent(context, steeringPin);
        steering.setAngle(ROTATE_ZERO);
    }

    @Override
    public void run() {
        try {
            long toStop = 0;
            int mul = 1000;
            while (!Thread.currentThread().isInterrupted()) {
                if (inputSpeed < 0 && prevSpeed >= 0)
                    switchToBackward();

                if (inputSpeed > 0 && inputSpeed <= 1)
                    esc.writeMicroseconds(map((int) (inputSpeed * mul), 0, mul, FORWARD_MIN, FORWARD_MAX));
                else if (inputSpeed < 0 && inputSpeed >= -1)
                    esc.writeMicroseconds(map((int) (inputSpeed * mul), -mul, 0, BACKWARD_MAX, BACKWARD_MIN));
                else {
                    if(prevSpeed > 0) {
                        toStop = System.nanoTime();
                        esc.writeMicroseconds(FORWARD_BRAKE);
                        Thread.sleep(40);
                    } else if(prevSpeed < 0) {
                        toStop = System.nanoTime();
                        esc.writeMicroseconds(BACKWARD_BRAKE);
                        Thread.sleep(40);
                    }
                    if(System.nanoTime() - toStop >= 1000) {
                        esc.writeMicroseconds(STOP);
                    }
                }

                if (inputAngle == 0)
                    steering.setAngle(ROTATE_ZERO);
                else
                    steering.setAngle(map((int) (inputAngle * mul), -mul, mul, ROTATE_LEFT_MAX, ROTATE_RIGHT_MAX));

                prevAngle = inputAngle;
                prevSpeed = inputSpeed;
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            esc.writeMicroseconds(STOP);
            steering.setAngle(ROTATE_ZERO);
        }
    }

    public void resetAll() {
        inputSpeed = 0;
        inputAngle = 0;
    }

    public void setInputSpeed(float inputSpeed) {
        this.inputSpeed = inputSpeed;
    }

    public void setInputWheelAngle(float inputAngle) {
        this.inputAngle = inputAngle;
    }

    private void switchToBackward() throws InterruptedException {
        esc.writeMicroseconds(STOP);
        Thread.sleep(40);
        esc.writeMicroseconds(BACKWARD_MIN);
        Thread.sleep(40);
        esc.writeMicroseconds(STOP);
        Thread.sleep(40);
        esc.writeMicroseconds(BACKWARD_MIN);
    }

    private int map(int val, int inMin, int inMax, int outMin, int outMax) {
        return (val - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
    }

    private Context buildNewContext() {
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
