import RPi.GPIO as gpio

gpio.setmode(gpio.BCM)
MAG_PIN = 23

class MagListener(object):
    def __init__(self, pin=MAG_PIN):
        self.pin = pin
        gpio.setup(MAG_PIN, gpio.IN)

    def __del__(self):
        gpio.cleanup(self.pin)

    def is_mag_present(self):
        if gpio.input(self.pin) == 1:
            return False
        else:
            return True
