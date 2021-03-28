cd "folder-with-videos-absolute"
for %%i in (*.mp4) do echo file '%%i'>> concatList.txt
echo "ffmpeg -f concat -safe 0 -i ABS:/path/to/concatList.txt -an combined.mp4"