<#
  Finds all files which don't exist, given a list of filenames (without extensions) and a persistent directory where the files should be stored.
#>

param(
    #[Parameter(Mandatory=$true)]
    [string]
    $FilenamesFile, # This should be a newline-deliminated list

    #[Parameter(Mandatory=$true)]
    [string]
    $PersistentDirectory)

$sourceFiles = [IO.File]::ReadAllLines($FilenamesFile)
$existingFiles = Get-ChildItem $PersistentDirectory -Recurse

$foundFiles = 0
$parsedFiles = 0
Write-Output "Read in $($sourceFiles.Count) file names to search for."
foreach ($filename in $sourceFiles)
{
    # Inefficient, but good enough for the scale of files I'm using.
    $foundFile = $false
    foreach ($existingFile in $existingFiles)
    {
        if ([IO.Path]::GetFileNameWithoutExtension($existingFile.Name.ToString()).Equals($filename, [StringComparison]::OrdinalIgnoreCase))
        {
            $foundFile = $true
            break
        }
    }

    if (-not $foundFile)
    {
        Write-Output $filename
    }
    else
    {
        ++$foundFiles
    }

    ++$parsedFiles
    if ($parsedFiles % 50 -eq 0)
    {
        Write-Output "-- $parsedFiles of $($sourceFiles.Count)"
    }
}

Write-Output "$($sourceFiles.Count) total files, $foundFiles files found."