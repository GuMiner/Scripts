<#
.DESCRIPTION
Splits and re-encodes MP4 videos (yuv240p) based on the specified parameters 

.PARAMETER File
The file to process

.PARAMETER Start
The start (in seconds)

.PARAMETER End
The end time (in seconds)

.PARAMETER FFmpegPath
The path to ffmpeg
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$File,
    
    [Parameter(Mandatory=$true)]
    [int]$Start,

    [Parameter(Mandatory=$true)]
    [int]$End)

$FFmpegPath = "C:\Users\gusgr\Desktop\Programs\ffmpeg\bin\ffmpeg.exe"


$difference = $End - $Start
$minutes = 0
while ($Start -ge 60)
{
    $minutes = $minutes + 1
    $Start = $Start - 60
}

$outputFilename = "$([IO.Path]::GetDirectoryName($file))\$([IO.Path]::GetFileNameWithoutExtension($file))-cut.mp4"
& $FFmpegPath -ss 00:0$($minutes):$Start -i $File -to 00:00:$difference -pix_fmt yuv420p $outputFilename