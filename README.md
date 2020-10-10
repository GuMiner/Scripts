# Scripts
Holds Windows scripts to simplify various repetitive actions

## Dependencies
Some of the scripts require external tools. You can find them from these links.
* [FFmpeg](https://ffmpeg.org/download.html#build-windows)
* [HandBrakeCLI](https://handbrake.fr/downloads2.php)
* [jpeg-archive](https://github.com/danielgtaylor/jpeg-archive/releases)
* [Python 3.7+](https://www.python.org/downloads/)

## File Management

### Find-DuplicateFiles.ps1
Finds duplicate files from one directory in another directory structure.

Effectively, this is the inverse of the **Verify-TransientFilesAreSaved** script.

### Find-MissingFilesByReference.ps1
Finds all files which don't exist, given a list of filenames (without extensions) and a persistent directory where the files should be stored.

This is useful to verify that all files in a list of filenames are backed up in a persistent directory.

### Remove-DuplicateFiles.ps1
Removes all files in a folder which are duplicate.

Useful to clear out a folder of files that are stored elsewhere.

### Rename-FileExtensions.ps1
Bulk renames file extensions in a directory.

This is useful to perform bulk case conversions (.PNG to .png, .MP3 to .mp3, etc) for operating-system invariant file storage.

### Verify-TransientFilesAreSaved.ps1
Verifies that files in a directory are backed up in another directory structure.

This is useful when burning media CDs, to ensure that files copied to the burn disk aren't inadvertently deleted from persistent storage.

## Media Conversion

### Compress-JpegImages.ps1
> Requires the jpeg-archive tool

Compresses JPEG images in a folder into indistinguishable (but much smaller) folders.

### BulkConvertToMp4.bat
> Requires the FFmpeg tool

Converts a series of files to MP4

This is useful to reduce the file size of inadequately-compressed videos and to standardize video formats such that all videos play adequately.

### PngTo30FpsMp4.bat
> Requires the FFmpeg tool

Converts a series of numbered PNG files to a 30 FPS MP4 video

This is useful when making a video from [POV-Ray](http://povray.org/) still image renders.

## SlowMotionVideo
> Requires the FFmpeg and HandBrakeCLI tools, along with a Python 3.7+ installation.

Converts HEVC slow motion video (240 FPS) to MP4 slowed-down video (29 FPS)

This is a graphical tool - drag and drop landscape files into *HEVC-to-MP4* and then drag the output to *240-to-29fps-audio.bat*.
You'll need to edit the Python files to point to your local installations of FFmpeg and HandBrakeCli for this tool to work.

## Other
### FFmpegSnippets.txt
> Requires the FFmpeg tool

Useful snippets for using FFmpeg.

### Bulk-GrayscaleConversion.ps1
Used in [TopographicRasterizer](https://github.com/GuMiner/TopographicRasterizer) to generate 3D printable terrain of several locations at once.

See the [Example Workflow](https://github.com/GuMiner/TopographicRasterizer/blob/master/Example/Example.md) for more information.

### Get-Images.ps1
Downloads all images of a Flickr user. Requires an API key.

This script is intended for small, personal Flickr accounts, so there's no rate-limiting or throttle detection.