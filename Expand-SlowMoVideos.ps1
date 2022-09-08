<#
.DESCRIPTION
Automates the drag-and-drop HEVC-to-MP4 and 240-to-29fps conversion scripting.
The process will run on all landscape (and 240 fps) files only in the specified $Folder

.PARAMETER Folder
The folder with files to process

.PARAMETER ExifToolPath
The path to 'exiftool.exe' to get video FPS and size.

.PARAMETER SlowMotionConversionPath
The folder with the drag-and-drop slow motion scripting.

.PARAMETER DeleteMovFile
Whether to default the *.MOV HEVC file (and 240 FPS MP4 file) after conversion. Defaults to $true.
#>
$Folder = "C:\Users\gusgr\OneDrive\Pictures\Camera Roll\2022\07"

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
        if ($frameRate -ge 200 -and $imageWidth -eq 1920) {
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
        } elseif ($imageWidth -eq 1920) {
            Write-Output "  Frame rate: $frameRate, width of $imageWidth"
            Write-Output "  Converting to .MP4..."
            C:\ml\python-3.8\python.exe $SlowMotionConversionPath\scripts\HEVC-to-MP4.py $file

            $mp4Filename = "$([IO.Path]::GetDirectoryName($file))\$([IO.Path]::GetFileNameWithoutExtension($file)).mp4"
            Write-Output "  Converting to a better color format..."
            
            C:\ml\python-3.8\python.exe $SlowMotionConversionPath\scripts\convert-to-yuv420p.py $mp4Filename

            if ($DeleteMovFile) {
                Write-Output "  Deleting HEVC..."
                [IO.File]::Delete($file)
                [IO.File]::Delete($mp4Filename)
            }
        } else {
            Write-Output "  Ignoring, frame rate is $frameRate and width is $imageWidth"
        }
    }
}