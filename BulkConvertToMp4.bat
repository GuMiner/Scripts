echo Usage: BulkConvertToMp4 PathOfFiles FileExtension
echo ffmpeg is expected to be in the current directory or in the path.
FOR %%i IN ("%1\*.%2") DO (ffmpeg -i "%%i" "%1\%%~ni.mp4")