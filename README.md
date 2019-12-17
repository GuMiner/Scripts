# Scripts
Maintains scripts to simplify various small actions

## File Management

### Verify-TransientFilesAreSaved
Verifies that files in a directory are backed up in another directory structure.

This is useful when burning media CDs, to ensure that files copied to the burn disk aren't inadvertently deleted from persistent storage.

### Find-DuplicateFiles
Finds duplicate files from one directory in another directory structure.

Effectively, this is the inverse of the **Verify-TransientFilesAreSaved** script.

### Rename-FileExtensions
Bulk renames file extensions in a directory.

This is useful to perform bulk case conversions (.PNG to .png, .MP3 to .mp3, etc) for operating-system invariant file storage.

## File Conversion

### Compress-JpegImages
Compresses JPEG images in a folder into indistinguishable (but much smaller) folders.

### BulkConvertToMp4
Converts a series of files to MP4

This is useful to reduce the file size of inadequately-compressed videos and to standardize video formats such that all videos play adequately.

### PngTo30FpsMp4
Converts a series of numbered PNG files to a 30 FPS MP4 video

This is useful when making a video from [POV-Ray](http://povray.org/) still renders.

## Other
### FFmpeg Snippets
Useful snippets for using FFmpeg