import RPi.GPIO as gpio
import time

gpio.setmode(gpio.BCM)
TRIG_PIN = 22
ECHO_PIN = 27

class SonarListener(object):
    def __init__(self, trig=TRIG_PIN, echo=ECHO_PIN):
        self.trig = trig
        self.echo = echo
        gpio.setup(self.trig, gpio.OUT)
        gpio.setup(self.echo, gpio.IN)

    def __del__(self):
        gpio.cleanup([self.trig, self.echo])

    def get_distance(self):
        gpio.output(self.trig, True)
        time.sleep(0.00001)
        gpio.output(self.trig, False)

        start_time = time.time()
        stop_time = time.time()

        while gpio.input(self.echo) == 0:
            start_time = time.time()
        while gpio.input(self.echo) == 1:
            stop_time = time.time()

        total_time = stop_time-start_time
        distance = (total_time * 34300) / 2
        return distance

if __name__ == "__main__":
    sonar = SonarListener()
    while True:
        print sonar.get_distance()
        time.sleep(0.5)
