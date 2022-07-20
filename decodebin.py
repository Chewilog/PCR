import csv
import struct
from codecs import decode
from ctypes import *
import numpy as np

libc = CDLL('msvcrt')


def bin_to_float(binary):
    return struct.unpack('!f',struct.pack('!I', int(binary, 2)))[0]

saidas = []
with open('iladata.csv') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    for row in csv_reader:
        if row[4] == '1':
            saidas.append(bin_to_float(row[5] + "00000"))

saidas = saidas[1::]


file = open("filefx.txt","r")
Y = []

for line in file.readlines():
   Y.append(float(line))


mse=0
for i in range(len(saidas)):
    mse+=(saidas[i]-Y[i])**2

print(mse/len(saidas))

# for i in saidas:
#     print(i)

