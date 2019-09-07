<#
.DESCRIPTION
Runs jpeg-recompress (https://github.com/danielgtaylor/jpeg-archive) on a folder of JPEG files.

.PARAMETER Folder
The folder with files to process

.PARAMETER JpegRecompressPath
The path to 'jpeg-recompress.exe' to run to recompress files.
#>
param(
    [Parameter(Mandatory=$true)]
    [string]
    $Folder,

    [Parameter(Mandatory=$true)]
    [string]
    $JpegRecompressPath)

foreach ($file in [IO.Directory]::GetFiles($Folder))
{
    if ($file.EndsWith("jpg", [StringComparison]::OrdinalIgnoreCase))
    {
        Write-Output "Processing $file ..."
        & $JpegRecompressPath -q high $file $file
    }
}