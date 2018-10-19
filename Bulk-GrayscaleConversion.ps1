<#
Performs ConvertTo-GrayscaleImage to a series of images.
#>
param(
    [Parameter(Mandatory=$true)]
    [string]
    $SourceFolder,

    [Parameter(Mandatory=$true)]
    [string]
    $DestinationFolder)

# X Coordinate
$directories = [IO.Directory]::GetDirectories($SourceFolder)
foreach ($directory in $directories)
{
    $subDir = [IO.Path]::Combine($DestinationFolder, [IO.Path]::GetFileName($directory))
    [IO.Directory]::CreateDirectory($subDir)

    # Y Coordinate
    foreach ($file in [IO.Directory]::GetFiles($directory))
    {
        Write-Output "Converting $([IO.Path]::GetFileName($directory)), $([IO.Path]::GetFileName($file))"
        .\ConvertTo-GrayscaleImage.ps1 -SourceImage $file -DestinationImage ([IO.Path]::Combine($subDir, [IO.Path]::GetFileName($file))) -MaxHeightValue 65536
    }
}