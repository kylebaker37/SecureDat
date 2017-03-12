import RPi.GPIO as gpio
import time
import picamera
import requests

gpio.setmode(gpio.BCM)
MAG_PIN = 23

class Camera(object):
    def __init__(self):
        self._camera = picamera.PiCamera()

    def capture(self, filename):
        self._camera.capture(filename)

    def record(self, filename, record_len):
        self._camera.start_recording(filename)
        time.sleep(record_len)
        self._camera.stop_recording()

class MagListener(object):
    def __init__(self, pin=MAG_PIN):
        self.pin = pin
        self.cam = Camera()
        gpio.setup(MAG_PIN, gpio.IN)

    def __del__(self):
        gpio.cleanup(self.pin)

    def _is_mag_present(self):
        if gpio.input(self.pin) == 1:
            return False
        else:
            return True

    def listen(self):
        prev = False
        cur = True
        while True:
            if self._is_mag_present():
                cur = True
            else:
                cur = False
            if prev == True and cur == False:
                print('door open')
                url = 'http://localhost/api/door_opened'
                payload = {'aid': 1}
                try:
                    print "Attempting connection..."
                    r = requests.get(url, json=payload)
                    print r.text
                    print "Connection complete..."
                except requests.exceptions.ConnectionError:
                    print "Connection failed..."
                print "Starting recording..."
                self.cam.record('opendoor.h264', 10)
                print "Finished recording..."
            time.sleep(0.05)
            prev = cur

if __name__ == '__main__':
    ml = MagListener()
    ml.listen()
    #c = Camera()
    #c.capture('capture.jpg')
    #c.record('record.h264', 5)
