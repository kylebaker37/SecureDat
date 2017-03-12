import picamera
import time

class Camera(object):
    def __init__(self):
        self._camera = picamera.PiCamera()

    def capture(self, filename):
        self._camera.capture(filename)

    def record(self, filename, record_len):
        self._camera.start_recording(filename)
        time.sleep(record_len)
        self._camera.stop_recording()
