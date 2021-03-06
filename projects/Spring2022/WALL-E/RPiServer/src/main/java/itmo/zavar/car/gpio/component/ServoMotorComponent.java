package itmo.zavar.car.gpio.component;

import com.pi4j.context.Context;
import com.pi4j.io.pwm.Pwm;
import com.pi4j.io.pwm.PwmConfig;
import com.pi4j.io.pwm.PwmType;

/**
 * Implementation of servo controller for raspberry pi using gpio.
 * Got from GitHub - pi4j-example-crowpi.
 *
 * @version 1.1
 * @author Zavar30
 */
public final class ServoMotorComponent {
    private final static int DEFAULT_FREQUENCY = 60;//IMPORTANT! Works correctly only at 60HZ
    private final static float DEFAULT_MIN_ANGLE = 0;
    private final static float DEFAULT_MAX_ANGLE = 180;
    private final static float DEFAULT_MIN_DUTY_CYCLE = 2;
    private final static float DEFAULT_MAX_DUTY_CYCLE = 12;
    private final Pwm pwm;
    private final float minAngle;
    private final float maxAngle;
    private final float minDutyCycle;
    private final float maxDutyCycle;

    /**
     * Creates a new step motor component with the given pin, angle range as well as duty cycle range.
     *
     * @param pi4j Pi4J context
     */
    public ServoMotorComponent(Context pi4j, int address) {
        this(pi4j, address, DEFAULT_MIN_ANGLE, DEFAULT_MAX_ANGLE, DEFAULT_MIN_DUTY_CYCLE, DEFAULT_MAX_DUTY_CYCLE);
    }

    /**
     * Creates a new step motor component with the given pin and frequency but customized angle and duty cycle values.
     * This can be used if the servo bundled with the CrowPi should for some reason have values which are totally off.
     *
     * @param pi4j         Pi4J context
     * @param address      Custom BCM pin address
     * @param minAngle     Minimum angle in degrees
     * @param maxAngle     Maximum angle in degrees
     * @param minDutyCycle Minimum duty cycle as float, between 0 and 100
     * @param maxDutyCycle Maximum duty cycle as float, between 0 and 100
     */
    public ServoMotorComponent(Context pi4j, int address, float minAngle, float maxAngle, float minDutyCycle, float maxDutyCycle) {
        this(pi4j, address, DEFAULT_FREQUENCY, minAngle, maxAngle, minDutyCycle, maxDutyCycle);
    }

    /**
     * Creates a new step motor component with given pin, frequency, angle range and duty cycle range values.
     *
     * @param pi4j         Pi4J context
     * @param address      Custom BCM pin address
     * @param frequency    Frequency used for PWM with servo
     * @param minAngle     Minimum angle in degrees
     * @param maxAngle     Maximum angle in degrees
     * @param minDutyCycle Minimum duty cycle as float, between 0 and 100
     * @param maxDutyCycle Maximum duty cycle as float, between 0 and 100
     */
    public ServoMotorComponent(Context pi4j, int address, int frequency, float minAngle, float maxAngle, float minDutyCycle, float maxDutyCycle) {
        this.pwm = pi4j.create(buildPwmConfig(pi4j, address, frequency));
        this.minAngle = minAngle;
        this.maxAngle = maxAngle;
        this.minDutyCycle = minDutyCycle;
        this.maxDutyCycle = maxDutyCycle;
    }

    /**
     * Sets steering angle in range: [0; 180]
     * @param angle Angle to set
     */
    public void setAngle(float angle) {
        pwm.on(mapAngleToDutyCycle(angle));
    }

    /**
     * Writes ms (like in Servo.h of Arduino Library) in range: [1000; 2000]
     * @param value Value to write
     */
    public void writeMicroseconds(int value) {
        int DEFAULT_MIN_MICROSECONDS = 1000;
        int DEFAULT_MAX_MICROSECONDS = 2000;
        pwm.on(mapToDutyCycle(value, DEFAULT_MIN_MICROSECONDS, DEFAULT_MAX_MICROSECONDS));
    }

    /**
     * Helper function to map an angle between {@link #minAngle} and {@link #maxAngle} to the configured duty cycle range.
     *
     * @param angle Desired angle
     * @return Duty cycle required to achieve this position
     */
    private float mapAngleToDutyCycle(float angle) {
        return mapToDutyCycle(angle, minAngle, maxAngle);
    }

    /**
     * Helper function to map an input value between a specified range to the configured duty cycle range.
     *
     * @param input      Value to map
     * @param inputStart Minimum value for custom range
     * @param inputEnd   Maximum value for custom range
     * @return Duty cycle required to achieve this position
     */
    private float mapToDutyCycle(float input, float inputStart, float inputEnd) {
        return mapRange(input, inputStart, inputEnd, minDutyCycle, maxDutyCycle);
    }

    /**
     * Helper function to map an input value from its input range to a possibly different output range.
     *
     * @param input       Input value to map
     * @param inputStart  Minimum value for input
     * @param inputEnd    Maximum value for input
     * @param outputStart Minimum value for output
     * @param outputEnd   Maximum value for output
     * @return Mapped input value
     */
    private float mapRange(float input, float inputStart, float inputEnd, float outputStart, float outputEnd) {
        // Automatically swap minimum/maximum of input if inverted
        if (inputStart > inputEnd) {
            final float tmp = inputEnd;
            inputEnd = inputStart;
            inputStart = tmp;
        }

        // Automatically swap minimum/maximum of output if inverted
        if (outputStart > outputEnd) {
            final float tmp = outputEnd;
            outputEnd = outputStart;
            outputStart = tmp;
        }

        // Automatically clamp the input value and calculate the mapped value
        final float clampedInput = Math.min(inputEnd, Math.max(inputStart, input));
        return outputStart + ((outputEnd - outputStart) / (inputEnd - inputStart)) * (clampedInput - inputStart);
    }

    /**
     * Builds a new PWM configuration for the step motor.
     *
     * @param pi4j      Pi4J context
     * @param address   BCM address
     * @param frequency PWM frequency
     * @return PWM configuration
     */
    private PwmConfig buildPwmConfig(Context pi4j, int address, int frequency) {
        return Pwm.newConfigBuilder(pi4j)
                .id("BCM" + address)
                .name("Servo Motor")
                .address(address)
                .pwmType(PwmType.HARDWARE)
                .frequency(frequency)
                .initial(0)
                .shutdown(0)
                .build();
    }
}