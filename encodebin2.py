import numpy as np
import struct

files_dict = {}
xs = []
num_in = 4

def float2bin(a,b,num):
    binrep = ''.join('{:0>8b}'.format(c) for c in struct.pack('!f', num))
    h = binrep[0:a+b+1]
    return h


for i in range(num_in):
    files_dict[i] = open('x'+str(i)+'.coe','w')
    files_dict[i].write("memory_initialization_radix=2;\nmemory_initialization_vector=\n")


source = open("Iris.txt",'r')
for line in source:
    aux = line[0:-1].split(',')
    for i in range(num_in):
        files_dict[i].write(float2bin(8, 18, float(aux[i]))+',\n')