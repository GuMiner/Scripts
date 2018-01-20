<#
Ensures that all files in the transient directory exist somewhere in the persistent directory tree.
Only compares file names and file lengths.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]
    $TransientDirectory,

    [Parameter(Mandatory=$true)]
    [string]
    $PersistentDirectory,
    
    [Parameter(Mandatory=$false)]
    [switch]
    $OnlyCompareFileNames)

$transientFiles = Get-ChildItem $TransientDirectory
$persistentFiles = Get-ChildItem $PersistentDirectory -Recurse

$foundCount = 0
foreach ($file in $transientFiles)
{
    $found = $false
    foreach ($persistentFile in $persistentFiles)
    {
        if ($persistentFile.Name -eq $file.Name)
        {
            if ($persistentFile.Length -eq $file.Length -or $OnlyCompareFileNames)
            {
                $found = $true
                ++$foundCount
                break;
            }
            else
            {
                Write-Warning "File $($persistentFile.Name) has a persistent length of $($persistentFile.Length / (1024 * 1024)) MB but a transient length of $($file.Length / (1024 * 1024)) MB. This does not count as a match."
            }
        }
    }

    if (-not $found)
    {
        Write-Output $file
    }
}

Write-Output "Found $foundCount of $($transientFiles.Count) files in the persistent directory structure."