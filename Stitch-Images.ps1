<#
.SYNOPSIS
Stitches a directory of images together.

.EXAMPLES
.\Stitch-Images.ps1 -SourceFolder "C:\Users\Gustave\Desktop\Hawaii\greyscale" -DestinationImage "C:\Users\Gustave\Desktop\Hawaii\hawaii.png" -Verbose
#>
param(
    [Parameter(Mandatory=$true)]
    [string]
    $SourceFolder,

    [Parameter(Mandatory=$false)]
    [int]
    $TileSize = 10,

    [Parameter(Mandatory=$false)]
    [int]
    $ImageSize = 1000,

    [Parameter(Mandatory=$false)]
    [string]
    $OSDrive = "C",

    [Parameter(Mandatory=$true)]
    [string]
    $DestinationImage)

[void][System.Reflection.Assembly]::LoadFile( "$($OSDrive):\Windows\Microsoft.NET\Framework\v2.0.50727\System.Drawing.dll")

$totalSize = $TileSize*$ImageSize
$newImage = New-Object 'System.Drawing.Bitmap' -ArgumentList $totalSize,$totalSize
$graphics = [System.Drawing.Graphics]::FromImage($newImage)

# X Coordinate
$x = 0
foreach ($directory in [IO.Directory]::GetDirectories($SourceFolder))
{
    $subDir = [IO.Path]::Combine($DestinationFolder, [IO.Path]::GetFileName($directory))
    [IO.Directory]::CreateDirectory($subDir)

    # Y Coordinate
    $y = 0
    foreach ($file in [IO.Directory]::GetFiles($directory))
    {
        Write-Output "Tiling $x, $y..."
        $image = New-Object 'System.Drawing.Bitmap' -ArgumentList $file
        
        $graphics.DrawImage($image, $y*$ImageSize, $x*$ImageSize, $ImageSize, $ImageSize)
        ++$y
    }

    ++$x
}

$graphics.Dispose()
$newImage.Save($DestinationImage)