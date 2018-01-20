<#
Finds duplicate files from one directory in another directory structure.
Only compares file names and file lengths.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]
    $SourceDirectory,

    [Parameter(Mandatory=$true)]
    [string]
    $PotentialDuplicateDirectory)

$sourceFiles = Get-ChildItem $SourceDirectory
$potentialDuplicateFiles = Get-ChildItem $PotentialDuplicateDirectory -Recurse

foreach ($file in $sourceFiles)
{
    foreach ($potentialDuplicateFile in $potentialDuplicateFiles)
    {
        if ($potentialDuplicateFile.Name -eq $file.Name)
        {
            if ($potentialDuplicateFile.Length -eq $file.Length -or $OnlyCompareFileNames)
            {
                Write-Output "Found file $($potentialDuplicateFile.Name) in $($potentialDuplicateFile.DirectoryName) as a duplicate"
            }
            else
            {
                Write-Warning "Found file $($potentialDuplicateFile.Name) in $($potentialDuplicateFile.DirectoryName) with length $([int]($persistentFile.Length / (1024 * 1024))) MB but a source length of $([int]($file.Length / (1024 * 1024))) MB."
            }
        }
    }
}