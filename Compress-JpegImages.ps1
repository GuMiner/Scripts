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
$Folder = "C:\Users\gusgr\Downloads\Official"

$JpegRecompressPath = "C:\Users\gusgr\Desktop\Programs\jpeg-archive\jpeg-recompress.exe"

$ImageMagickPath = "C:\Users\gusgr\Desktop\Programs\ImageMagick\magick.exe"

$DeleteHeicFile = $true

foreach ($file in [IO.Directory]::GetFiles($Folder))
{
    if ($file.EndsWith("jpg", [StringComparison]::OrdinalIgnoreCase))
    {
        Write-Output "Processing $file ..."
        & $JpegRecompressPath -q high $file $file
    }
    elseif ($file.EndsWith("heic", [StringComparison]::OrdinalIgnoreCase))
    {
        $jpgFilename = "$([IO.Path]::GetDirectoryName($file))\$([IO.Path]::GetFileNameWithoutExtension($file)).jpg"

        Write-Output "Converting $file ..."
        & $ImageMagickPath convert $file $jpgFilename

        if ($DeleteHeicFile) {
            [IO.File]::Delete($file)
        }

        Write-Output "Processing $jpgFilename ..."
        & $JpegRecompressPath -q high $jpgFilename $jpgFilename
    }
}