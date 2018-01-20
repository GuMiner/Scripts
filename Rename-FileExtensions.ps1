<#
Bulk-renames the extension of files within a specified directory.
#>
param(
    [Parameter(Mandatory=$true)]
    [string]
    $SourceDirectory,
    
    [Parameter(Mandatory=$true)]
    [string]
    $NewExtension)
    
foreach ($file in [System.IO.Directory]::GetFiles($SourceDirectory))
{
    Rename-Item $file ([IO.Path]::Combine([IO.Path]::GetDirectoryName($file), "$([IO.Path]::GetFileNameWithoutExtension($file)).$NewExtension"))
}