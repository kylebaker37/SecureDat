import RPi.GPIO as gpio

gpio.setmode(gpio.BCM)
MAG_PIN = 9

class IRListener(object):
    def __init__(self, pin=MAG_PIN):
        self.pin = pin
        gpio.setup(MAG_PIN, gpio.IN)

    def __del__(self):
        gpio.cleanup(self.pin)

    def is_ir_present(self):
        if gpio.input(self.pin) == 1:
            return False
        else:
            return True


if __name__ == "__main__":
    import time
    ir = IRListener()
    while True:
        if ir.is_ir_present():
            print "Yup"
        else:
            print "Nah"
        time.sleep(0.05)
