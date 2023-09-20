<#
.DESCRIPTION
Converts huge PNG files to reasonable JPG files.

.PARAMETER Folder
The folder with files to process

.PARAMETER JpegRecompressPath
The path to 'jpeg-recompress.exe' to run to recompress files.

.PARAMETER ImageMagickPath
The path to 'magick.exe' to convert PNG files to JPG files.
#>
$Folder = "C:\Users\gusgr\OneDrive\Pictures\Camera Roll\2022\09"

$JpegRecompressPath = "C:\Users\gusgr\Desktop\Programs\jpeg-archive\jpeg-recompress.exe"

$ImageMagickPath = "C:\Users\gusgr\Desktop\Programs\ImageMagick\magick.exe"

$DeletePngFile = $true

foreach ($file in [IO.Directory]::GetFiles($Folder))
{
    if ($file.EndsWith("png", [StringComparison]::OrdinalIgnoreCase))
    {
        $jpgFilename = "$([IO.Path]::GetDirectoryName($file))\$([IO.Path]::GetFileNameWithoutExtension($file)).jpg"

        Write-Output "Converting $file ..."
        & $ImageMagickPath convert $file $jpgFilename

        Write-Output "Processing $jpgFilename ..."
        & $JpegRecompressPath -q high $jpgFilename $jpgFilename

        Write-Output "Size Difference: $((100*(Get-Item $jpgFilename).length)/((Get-Item $file).length))%"
        if ($DeletePngFile) {
            [IO.File]::Delete($file)
        }
    }
}