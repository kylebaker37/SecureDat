import RPi.GPIO as gpio
import time

gpio.setmode(gpio.BCM)
MAG_PIN = 23

class MagListener(object):
    def __init__(self, pin=MAG_PIN):
        self.pin = pin
        gpio.setup(MAG_PIN, gpio.IN)

    def __del__(self):
        gpio.cleanup(self.pin)

    def _is_mag_present(self):
        if gpio.input(self.pin) == 1:
            return False
        else:
            return True

    def listen(self):
        while True:
            if self._is_mag_present():
                print "Present"
                # Do some network request to our endpoint
            time.sleep(0.05)

if __name__ == '__main__':
    ml = MagListener()
    ml.listen()
