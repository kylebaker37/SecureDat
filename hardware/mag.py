import RPi.GPIO as gpio
import time

gpio.setmode(GPIO.BCM)

mag_pin = 23
gpio.setup(mag_pin, gpio.IN)

def is_mag_present():
    if gpio.input(mag_pin) == 1:
        return False
    else:
        return True


if __name__ == '__main__':
    try:
        while True:
            if is_mag_present():
                print "Mag!"
            else:
                print "No Mag!"
            time.sleep(0.5)
    except KeyboardInterrupt:
        print "Stopped..."
        gpio.cleanup()