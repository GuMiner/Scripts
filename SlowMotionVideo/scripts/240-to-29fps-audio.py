import os
import subprocess
import sys


if len(sys.argv) < 2:
    print("Expected a 240 FPS file to slow down 8x")
    print(sys.argv)
    sys.exit(1)

slowdown = 8

cmd = 'C:\\users\\gusgr\\Desktop\\Programs\\ffmpeg\\bin\\ffmpeg.exe'
input = sys.argv[1]
output = f'{os.path.splitext(input)[0]}-slow.mp4'

args = [cmd, '-i', input, '-filter:v', f'setpts={slowdown}*PTS', '-pix_fmt', 'yuv420p', '-r', '29', output]
print(args)
process = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
for line in iter(process.stdout.readline, b''):
    line = line.decode(sys.stdout.encoding)
    if line and not line.isspace():
        print(line)
