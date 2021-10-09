<#
.DESCRIPTION
Runs jpeg-recompress (https://github.com/danielgtaylor/jpeg-archive) on a folder of JPEG files.
Converts HEIC files to JPG too, as that saves ~1 MB per file.

.PARAMETER Folder
The folder with files to process

.PARAMETER JpegRecompressPath
The path to 'jpeg-recompress.exe' to run to recompress files.

.PARAMETER ImageMagickPath
The path to 'magick.exe' to convert HEIC files to JPG files.
#>
$Folder = "C:\Users\gusgr\OneDrive\Pictures\Camera Roll\2021\09"

$ExifToolPath = "C:\Users\gusgr\Desktop\Programs\exiftool\exiftool.exe"

$SlowMotionConversionPath = "C:\Users\gusgr\Desktop\Active\Scripts\SlowMotionVideo"

$DeleteMovFile = $true

foreach ($file in [IO.Directory]::GetFiles($Folder))
{
    if ($file.EndsWith("MOV", [StringComparison]::OrdinalIgnoreCase))
    {
        Write-Output "Processing $file ..."
        $fileData = & $ExifToolPath $file

        $frameRate = [float]::Parse($($fileData | Select-String -Pattern "Video Frame Rate").ToString().Split(':')[1].Trim())
        $imageWidth = [int]::Parse($($fileData | Select-String -Pattern "Source Image Width").ToString().Split(':')[1].Trim())
        if ($frameRate -ge 240 -and $imageWidth -eq 1920) {
            Write-Output "  Frame rate: $frameRate, width of $imageWidth"
            Write-Output "  Converting to .MP4..."
            C:\ml\python-3.8\python.exe $SlowMotionConversionPath\scripts\HEVC-to-MP4.py $file

            
            $mp4Filename = "$([IO.Path]::GetDirectoryName($file))\$([IO.Path]::GetFileNameWithoutExtension($file)).mp4"
            Write-Output "  Creating slow-motion video..."
            
            C:\ml\python-3.8\python.exe $SlowMotionConversionPath\scripts\240-to-29fps-audio.py $mp4Filename
         
            if ($DeleteMovFile) {
                Write-Output "  Deleting temporary files..."
                [IO.File]::Delete($file)
                [IO.File]::Delete($mp4Filename)
            }
        } else {
            Write-Output "  Ignoring, frame rate is $frameRate and width is $imageWidth"
        }
    }
}