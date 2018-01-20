echo Usage: PngTo30FpsMp4.bat ImagePrefix OutputVideoName
echo ffmpeg is expected to be in the current directory or in the path.
ffmpeg -r 30 -i %1%%03d.png -c:v libx264 -pix_fmt yuv420p %2.mp4