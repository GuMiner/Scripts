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
$Folder = "C:\Users\gusgr\Desktop\toprocess\walkthroughs"

$ExifToolPath = "C:\Users\gusgr\Desktop\Programs\exiftool\exiftool.exe"

$SlowMotionConversionPath = "C:\Users\gusgr\Desktop\Active\Scripts\SlowMotionVideo"

$DeleteMovFile = $true
$DeleteHEVCFile = $true

foreach ($file in [IO.Directory]::GetFiles($Folder)) {
    if ($file.EndsWith("MP4", [StringComparison]::OrdinalIgnoreCase)) {
        Write-Output "Checking MP4 $file ..."

        # Figure out if the current EXIF information indicates this needs to be converted to the more standard formats
        $fileData = & $ExifToolPath $file
        # Write-Output $fileData
        
        $imageWidth = [int]::Parse($($fileData | Select-String -Pattern "Source Image Width").ToString().Split(':')[1].Trim())
        $imageHeight = [int]::Parse($($fileData | Select-String -Pattern "Source Image Height").ToString().Split(':')[1].Trim())
        $frameRate = [int]::Parse($($fileData | Select-String -Pattern "Video Frame Rate").ToString().Split(':')[1].Trim().Split('.')[0])
        $videoFormat = ($fileData | Select-String -Pattern "Compressor ID").ToString().Split(':')[1].Trim()
        Write-Output "  $imageWidth x $imageHeight @ $frameRate ($videoFormat)"


        # 1920x1080 30 FPS HEVC -> 1920x1080 30 FPS AVC
        if ($imageWidth -eq 1920 -and $imageHeight -eq 1080 -and ($frameRate -eq 30 -or $frameRate -eq 29) -and $videoFormat -eq "hvc1") {
            Write-Output "  Converting HEVC to AVC..."
            C:\ml\python-3.8\python.exe $SlowMotionConversionPath\scripts\convert-to-yuv420p.py $file
            if ($DeleteHEVCFile) {
                Write-Output "  Deleting HEVC..."
                [IO.File]::Delete($file)
            }
        }
    }
    elseif ($file.EndsWith("MOV", [StringComparison]::OrdinalIgnoreCase)) {
        Write-Output "Processing MOV $file ..."
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