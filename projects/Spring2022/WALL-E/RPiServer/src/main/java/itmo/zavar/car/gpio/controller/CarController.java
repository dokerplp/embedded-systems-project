package itmo.zavar.car.gpio.controller;

import com.pi4j.Pi4J;
import com.pi4j.context.Context;
import com.pi4j.exception.Pi4JException;
import com.pi4j.io.i2c.I2C;
import com.pi4j.io.i2c.I2CConfigBuilder;
import com.pi4j.library.pigpio.PiGpio;
import com.pi4j.plugin.pigpio.provider.gpio.digital.PiGpioDigitalInputProvider;
import com.pi4j.plugin.pigpio.provider.gpio.digital.PiGpioDigitalOutputProvider;
import com.pi4j.plugin.pigpio.provider.i2c.PiGpioI2CProvider;
import com.pi4j.plugin.pigpio.provider.pwm.PiGpioPwmProvider;
import com.pi4j.plugin.pigpio.provider.serial.PiGpioSerialProvider;
import com.pi4j.plugin.pigpio.provider.spi.PiGpioSpiProvider;
import com.pi4j.plugin.raspberrypi.platform.RaspberryPiPlatform;
import itmo.zavar.car.gpio.component.ServoMotorComponent;
import org.apache.logging.log4j.LogManager;

/**
 * Implementation of car controller using gpio
 *
 * @version 1.3
 * @author Zavar30
 */
public final class CarController implements Runnable {
    /**
     * Constants for ESC (length of impulse, ms)
     */
    private final static int STOP = 1550;
    private final static int FORWARD_BRAKE = 1300;
    private final static int FORWARD_MAX = 1850;
    private final static int FORWARD_MIN = 1610;
    private final static int BACKWARD_BRAKE = 1590;
    private final static int BACKWARD_MAX = 1490;
    private final static int BACKWARD_MIN = 1518;
    /**
     * Constants for steering servo (angle)
     */
    private final static int ROTATE_RIGHT_MAX = 95;
    private final static int ROTATE_ZERO = 128;
    private final static int ROTATE_LEFT_MAX = 160;

    public final ServoMotorComponent esc;
    public final ServoMotorComponent steering;
    public final I2C battery;
    private volatile float inputSpeed = 0.0F;
    private volatile float inputAngle = 0.0F;
    private float prevSpeed = 0.0F;
    private float prevAngle = 0.0F;
    private volatile String batteryValue = "0-0";

    /**
     * Controller setup, sets ESC at STOP ({@value STOP}) value and sets steering servo at ZERO
     * ({@value ROTATE_ZERO}) value
     *
     * @param escPin GPIO pin for ESC
     * @param steeringPin GPIO pin for steering servo
     * @param batteryAddress I2C address for arduino (sends voltage sensors values)
     */
    public CarController(int escPin, int steeringPin, int batteryAddress) {
        PiGpio piGpio = PiGpio.newNativeInstance();
        Context context = buildNewContext(piGpio);
        esc = new ServoMotorComponent(context, escPin);
        esc.writeMicroseconds(STOP);
        steering = new ServoMotorComponent(context, steeringPin);
        steering.setAngle(ROTATE_ZERO);
        battery = PiGpioI2CProvider.newInstance(piGpio).create(
                I2CConfigBuilder.newInstance(context).
                        bus(1).
                        device(batteryAddress).
                        id(String.valueOf(batteryAddress)).
                        build());
    }

    @Override
    public void run() {
        try {
            long toStop = 0;
            int mul = 1000;
            while (!Thread.currentThread().isInterrupted()) {
                try {
                    //getting value from I2C and remove bad symbols
                        batteryValue = new String(battery.readCharArray(7)).replaceAll("[^A-Za-zА-Яа-я0-9\\-]", "");
                    //if direction is changed - we should change ESC direction (see method doc below)
                    if (inputSpeed < 0 && prevSpeed >= 0)
                        switchToBackward();

                    if (inputSpeed > 0 && inputSpeed <= 1)
                        esc.writeMicroseconds(map((int) (inputSpeed * mul), 0, mul, FORWARD_MIN, FORWARD_MAX));
                    else if (inputSpeed < 0 && inputSpeed >= -1)
                        esc.writeMicroseconds(map((int) (inputSpeed * mul), -mul, 0, BACKWARD_MAX, BACKWARD_MIN));
                    else {
                        //enabling brake mode in ESC. Depends on ESC, check manual
                        if(prevSpeed > 0) {
                            toStop = System.currentTimeMillis();
                            esc.writeMicroseconds(FORWARD_BRAKE);
                            Thread.sleep(50);
                        } else if(prevSpeed < 0) {
                            toStop = System.currentTimeMillis();
                            esc.writeMicroseconds(BACKWARD_BRAKE);
                            Thread.sleep(250);
                            esc.writeMicroseconds(BACKWARD_MIN);
                            prevSpeed = 0;
                        }
                        //stops the car
                        if(System.currentTimeMillis() - toStop >= 1000) {
                            esc.writeMicroseconds(STOP);
                        }
                    }

                    //sets steering angle
                    if (inputAngle == 0)
                        steering.setAngle(ROTATE_ZERO);
                    else
                        steering.setAngle(map((int) (inputAngle * mul), -mul, mul, ROTATE_LEFT_MAX, ROTATE_RIGHT_MAX));
                } catch (Pi4JException e) {
                    LogManager.getLogger(CarController.class.getName()).error(e.getMessage());
                }
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            //stops car on interruption or on throwing exception
            esc.writeMicroseconds(STOP);
            steering.setAngle(ROTATE_ZERO);
        }
    }

    /**
     * Sets speed to 0 and steering angle to neutral position
     */
    public void resetAll() {
        inputSpeed = 0;
        inputAngle = 0;
    }

    /**
     * @return Two values in format: 'v1-v2', every value in range: [0; 100]
     */
    public String getBatteryValue() {
        return batteryValue;
    }

    /**
     * Sets car's speed
     * @param inputSpeed Speed in range: [-1; 1], zero speed stops the car
     * @throws IllegalArgumentException If speed is out of range
     */
    public void setInputSpeed(float inputSpeed) throws IllegalArgumentException  {
        if(Math.abs(inputSpeed) > 1)
            throw new IllegalArgumentException("Speed range: [-1; 1], check your input");
        prevSpeed = this.inputSpeed;
        this.inputSpeed = inputSpeed;
    }

    /**
     * Sets steering angle's speed
     * @param inputAngle Steering angle in range: [-1; 1], zero angle sets steering servo to neutral position
     * @throws IllegalArgumentException If angle is out of range
     */
    public void setInputWheelAngle(float inputAngle) throws IllegalArgumentException {
        if(Math.abs(inputAngle) > 1)
            throw new IllegalArgumentException("Angle range: [-1; 1], check your input");
        prevAngle = this.inputAngle;
        this.inputAngle = inputAngle;
    }

    /**
     * Utility method. Requires for ESC which turns on reverse with a certain combination of control signals.
     * Check ESC manual before coding.
     */
    private void switchToBackward() throws InterruptedException {
        esc.writeMicroseconds(STOP);
        Thread.sleep(40);
        esc.writeMicroseconds(BACKWARD_MIN);
        Thread.sleep(40);
        esc.writeMicroseconds(STOP);
        Thread.sleep(40);
        esc.writeMicroseconds(BACKWARD_MIN);
    }

    /**
     * Utility method. Converts value from one range to another one.
     * @param val Input value for conversation
     * @param inMin Input's range min value
     * @param inMax Input's range max value
     * @param outMin Output's range min value
     * @param outMax Output's range max value
     * @return New value after conversation
     */
    private int map(int val, int inMin, int inMax, int outMin, int outMax) {
        return (val - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
    }

    private Context buildNewContext(PiGpio piGpio) {
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
