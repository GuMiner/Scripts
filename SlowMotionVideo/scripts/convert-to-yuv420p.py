import os
import subprocess
import sys


if len(sys.argv) < 2:
    print("Expected a singluar file")
    print(sys.argv)
    sys.exit(1)

slowdown = 8

cmd = 'C:\\users\\gusgr\\Desktop\\Programs\\ffmpeg\\bin\\ffmpeg.exe'
input = sys.argv[1]
output = f'{os.path.splitext(input)[0]}-yuv420p.mp4'

args = [cmd, '-i', input, '-pix_fmt', 'yuv420p', output]
print(args)
process = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
for line in iter(process.stdout.readline, b''):
    line = line.decode(sys.stdout.encoding)
    if line and not line.isspace():
        print(line)
