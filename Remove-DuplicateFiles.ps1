<#
 Deletes files in the transient directory which are equal. Does not run recursively.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]
    $TransientDirectory,

    [Parameter(Mandatory=$true)]
    [string]
    $PersistentDirectory,

    [switch]
    $SkipSizeComparison)

$transientFiles = Get-ChildItem $TransientDirectory
$persistentFiles = Get-ChildItem $PersistentDirectory

$removedCount = 0
foreach ($file in $transientFiles)
{
    foreach ($persistentFile in $persistentFiles)
    {
        if ($persistentFile.Name -eq $file.Name)
        {
            if ($persistentFile.Length -eq $file.Length -or $SkipSizeComparison)
            {
                ++$removedCount

                if (-not (Test-Path (Join-Path $TransientDirectory "deleted")))
                {
                    New-Item -ItemType directory -Path (Join-Path $TransientDirectory "deleted")
                }

                Move-Item (Join-Path $TransientDirectory $file) (Join-Path $TransientDirectory (Join-Path "deleted" $file))
                break;
            }
            else
            {
                Write-Warning "File $($persistentFile.Name) has a persistent length of $($persistentFile.Length / (1024 * 1024)) MB but a transient length of $($file.Length / (1024 * 1024)) MB. This does not count as a match."
            }
        }
    }
}

Write-Output "Removed $removedCount of $($transientFiles.Count) files in the persistent directory structure."