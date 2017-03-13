import time
import requests
import subprocess

from datetime import datetime
from mag import MagListener
from camera import Camera
from sonar import SonarListener

VID_PATH = '/home/pi/SecureDat/vids/'
BASE_URL = 'http://localhost:80/'


def main():
    cam = Camera()
    mag = MagListener()
    sonar = SonarListener()
    avg_distance = boot_sonar(sonar)
    cur = True
    prev = False
    while True:
        if check_motion(sonar, avg_distance):
            print "MOTION!!!"
            handle_motion_detected()
        if mag.is_mag_present():
            cur = True
        else:
            cur = False
        if prev == True and cur == False:
            handle_door_opened(cam)
        time.sleep(0.05)
        prev = cur

def handle_motion_detected():
    url = BASE_URL + 'api/door_opened'
    payload = {'aid': 1, 'type': 'motion'}
    try:
        print "Attempting to notify about motion..."
        r = requests.post(url, json=payload)
        print "Connection complete"
    except requests.exceptions.ConnectionError:
        print "Connection failed"
        
def boot_sonar(sonar):
    print "Doing initial sonar boot..."
    avg = 0
    for _ in range(10):
        avg += sonar.get_distance()
        time.sleep(0.05)
    avg = avg / 10
    return avg

def check_motion(sonar, average_distance):
    avg = 0
    for _ in range(5):
        avg += sonar.get_distance()
        time.sleep(0.05)
    avg = avg / 5
    if avg < average_distance*0.90:
        return True
    return False
    
def handle_door_opened(cam):
    notify_door_opened()
    mp4file, h264file = record_video(cam)
    convert_video(mp4file, h264file)
    notify_video_complete(mp4file)

def notify_door_opened():
    print "Door opened"
    url = BASE_URL + 'api/door_opened'
    payload = {'aid': 1}
    try:
        print "Attempting connection to %s..." % url
        r = requests.post(url, json=payload)
        print "Connection complete"
    except requests.exceptions.ConnectionError:
        print "Connection to %s failed" % url

def record_video(cam):
    print "Starting recording..."
    now = datetime.now()
    mp4file = VID_PATH + '{:%Y%m%dT%H%M%S}.mp4'.format(now)
    h264file = VID_PATH + '{:%Y%m%dT%H%M%S}.h264'.format(now)
    cam.record(h264file, 10)
    print "Finished recording"
    return mp4file, h264file

def convert_video(mp4file, h264file):
    print "Converting h264 file to mp4..."
    cmd = ('avconv -i %s -c:v copy -f mp4 %s' % (h264file, mp4file)).split(' ')
    p = subprocess.Popen(cmd)
    p.wait()
    print "Conversion complete"

def notify_video_complete(mp4file):
    try:
        print "Attempting to update video path..."
        url = BASE_URL + 'api/update_vid_path'
        payload = {'aid': 1, 'path': mp4file}
        r = requests.post(url, json=payload)
        print "Update complete"
    except requests.exceptions.ConnectionError:
        print "Connection to update_vid_path failed"

if __name__ == '__main__':
    main()
