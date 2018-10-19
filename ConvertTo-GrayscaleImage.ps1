<#
Converts a RGB PNG image representing a 16-bit heightmap (R: LSB. G: MSB, B: Unused) to a 8-bit normalized greyscale image.
#>
param(
    [Parameter(Mandatory=$true)]
    [string]
    $SourceImage,

    [Parameter(Mandatory=$true)]
    [string]
    $DestinationImage,
    
    [Parameter(Mandatory=$false)]
    [string]
    $OSDrive = "C",
    
    [Parameter(Mandatory=$false)]
    [switch]
    $UseWhiteAsMinInsteadOfMax,
    
    # If -1, computes a maximum heightmap value. Otherwise, uses the provided value.
    [Parameter(Mandatory=$false)]
    [int]
    $MaxHeightValue = -1)

[void][System.Reflection.Assembly]::LoadFile( "$($OSDrive):\Windows\Microsoft.NET\Framework\v2.0.50727\System.Drawing.dll")
Add-Type "public class Shift { public static int Right(int x) { return x << 8; }}"

$image = New-Object 'System.Drawing.Bitmap' -ArgumentList $SourceImage
$newImage = New-Object 'System.Drawing.Bitmap' -ArgumentList $image.Width, $image.Height

$maxValue = $MaxHeightValue
Write-Output "Current maximum heightmap value: 0"

if ($MaxHeightValue -eq -1)
{
    foreach ($i in 0 .. ($image.Width - 1))
    {
      foreach ($j in 0 .. ($image.Height - 1))
      {
        $color = $image.GetPixel($i, $j)
        $value = [int]$color.R + ([Shift]::Right([int]$color.G))
        if ($value -gt $maxValue)
        {
          $maxValue = $value
          Write-Output ("New maximum heightmap value: " + $maxValue)
        }
      }
    
      Write-Output "Processed column $i of $($image.Width))"
    }

    Write-Output ("Final maximum heightmap value: " + $maxValue.ToString())
}

$maxNorm = 255
foreach ($i in 0 .. ($image.Width - 1))
{
  foreach ($j in 0 .. ($image.Height - 1))
  {
    # Technically this is very inefficient as I can save the shifted 16-bit values instead of running a normalization pass
    #  and then an image generation pass, but this runs after a multi-hour process to *generate* the heightmaps, so the
    #  optimization here really isn't worth the effort right now
    $color = $image.GetPixel($i, $j)
    $value = [int]$color.R + ([Shift]::Right([int]$color.G))
    $newValue = $maxNorm * ([float]$value / [float]$maxValue)
    
    if ($UseWhiteAsMinInsteadOfMax)
    {
      $newValue = 255 - $newValue
    }

    $color = [System.Drawing.Color]::FromArgb([int]$newValue, [int]$newValue, [int]$newValue);
    $newImage.SetPixel($i, $j, $color);
  }

  Write-Output ("Converted column $i of $($image.Width)")
}

$newImage.Save($DestinationImage)
