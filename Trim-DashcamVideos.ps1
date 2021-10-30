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
    [string]$Start,

    [Parameter(Mandatory=$true)]
    [string]$End)

$FFmpegPath = "C:\Users\gusgr\Desktop\Programs\ffmpeg\bin\ffmpeg.exe"

$startParts = $Start.Split(@('.', ':'))
$endParts = $End.Split(@('.', ':'))

$startSeconds = 0
$startMinutes = 0
$endSeconds = 0
$endMinutes = 0

if ($startParts.Length -gt 1) {
    $startMinutes = [int]::Parse($startParts[0])
    $startSeconds = [int]::Parse($startParts[1])
} else {
    $startSeconds = [int]::Parse($Start)
}

if ($endParts.Length -gt 1) {
    $endMinutes = [int]::Parse($endParts[0])
    $endSeconds = [int]::Parse($endParts[1])
} else {
    $endSeconds = [int]::Parse($End)
}

$difference = ($endMinutes*60 + $endSeconds) - ($startMinutes*60 + $startSeconds)

$outputFilename = "$([IO.Path]::GetDirectoryName($file))\$([IO.Path]::GetFileNameWithoutExtension($file))-cut.mp4"
& $FFmpegPath -ss 00:0$($startMinutes):$startSeconds -i $File -to 00:00:$difference -pix_fmt yuv420p $outputFilename