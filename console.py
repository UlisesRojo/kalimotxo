#!/usr/bin/python3

import sys
import time
import Adafruit_DHT

# Configuracion del tipo de sensor DHT
sensor = Adafruit_DHT.DHT11

# Configuracion del puerto GPIO al cual esta conectado  (GPIO 23)
pin = 23

while True:
    # Obtiene la humedad y la temperatura desde el sensor 
    humedad, temperatura = Adafruit_DHT.read_retry(sensor, pin)
    
    # Imprime en la consola las variables temperatura y humedad con un decimal
    print('Temperatura={0:0.1f}*  Humedad={1:0.1f}%'.format(temperatura, humedad))

    # Duerme 10 segundos
    time.sleep(10)
