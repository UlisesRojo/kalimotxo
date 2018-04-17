#!/usr/bin/python3
"""
kalimotxo.py: a script for monitoring temperature and humidity using a DHT sensor
with a RaspberryPi. Reads input variables from a YAML file, and writes data to a
log with timestamps. Sends an email to warn users if temperature exceeds certain
value.
"""

import sys
import time
import datetime
import yaml
import smtplib
import Adafruit_DHT

def parse_input(infile):
    '''
    Parses a YAML input file.
    '''
    with open(infile) as data_file:
        params = yaml.load(data_file)
    return params

def readsensor(sensor, pin):
    return Adafruit_DHT.read_retry(sensor, pin)

def write_log(text):
   with open(PARAMS["log_file"], "a") as log:
        print(text, file=log)

def sendemail(text):
    s = smtplib.SMTP(PARAMS["mail"]["servidor"])
    s.sendmail(PARAMS["mail"]["from"], PARAMS["mail"]["to"].split(','), text)
    s.quit()


INFILE = sys.argv[1]
PARAMS = parse_input(INFILE)
FLAG = False
        
# Infinite cycle
while True:
    hum, temp = readsensor(Adafruit_DHT.DHT11, PARAMS["sensor"]["pin"])
    date = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    if hum is not None and temp is not None:
        write_log("{d} {t:04.1f} {h:04.1f}".format(d=date, t=temp, h=hum))
        if temp >= PARAMS["sensor"]["temp_cri"] and FLAG is False:
            string = ("Subject: URGENT MEDUSA TEMPERATURE WARNING\n"
                      "{d}\n\nURGENT:\n\nRoom temperature is currently at {t} C, "
                      "which is at or above the critical system temperature of {crit}.\n"
                      "Please check ASAP!").format(d=date, t=temp, crit=PARAMS["sensor"]["temp_cri"])
            sendemail(string)
            # print(string)
            FLAG = True
        elif temp < PARAMS["sensor"]["temp_cri"] and FLAG is True:
            FLAG = False
    else:
        write_log('Error reading sensor.')

    time.sleep(PARAMS["sensor"]["frec"])
