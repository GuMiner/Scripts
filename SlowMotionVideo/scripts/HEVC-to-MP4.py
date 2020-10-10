import os
import subprocess
import sys


if len(sys.argv) < 2:
    print("Expected a HEVC file to convert to MP4")
    print(sys.argv)
    sys.exit(1)

slowdown = 8

cmd = 'C:\\users\\Gustave\\Desktop\\Programs\\HandbrakeCLI\\HandbrakeCLI.exe'
input = sys.argv[1]
output = f'{os.path.splitext(input)[0]}.mp4'

args = [cmd, '--preset-import-file', 'scripts/HEVC-to-MP4-preset.json', '--preset',  '1080p-Landscape-HEVC-converter', '--input', input, '--output', output]
print(args)
process = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
for line in iter(process.stdout.readline, b''):
    line = line.decode(sys.stdout.encoding)
    if line and not line.isspace():
        print(line)
