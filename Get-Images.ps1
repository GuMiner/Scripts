<#
  Retrieves all Flickr photos for a given user from Flickr, saving their titles in the given output file.

  This is intended for small, personal Flickr sites, so there is no rate-limiting / throttle detection included in this short script.
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$UserId,
    
    [Parameter(Mandatory=$true)]
    [string]$ApiKey,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputFilename)

function ConvertFrom-FlickrJson
{
    param($FlikrJson)

    return ConvertFrom-Json $FlikrJson.Substring("jsonFlickrApi(".Length).TrimEnd(')')
}

[IO.File]::WriteAllText($OutputFilename, "")

$content = Invoke-RestMethod -Method Get -URI "https://api.flickr.com/services/rest/?method=flickr.photosets.getList&api_key=$ApiKey&user_id=$UserId&format=json"
$jsonContent = ConvertFrom-FlickrJson -FlikrJson:$content

Write-Output "Photosets: $($jsonContent.photosets.photoset.Count)"
foreach ($photoset in $jsonContent.photosets.photoset)
{
    Write-Output "Querying $($photoset.title)..."
    $content = Invoke-RestMethod -Method Get -URI "https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&api_key=$ApiKey&user_id=$UserId&photoset_id=$($photoset.id)&format=json"
    $photos = ConvertFrom-FlickrJson -FlikrJson:$content

    Write-Output "Read in $($photos.photoset.photo.Count) photos."
    foreach ($photo in $photos.photoset.photo)
    {
        [IO.File]::AppendAllText($OutputFilename, "$($photo.title)$([Environment]::NewLine)")
    }
}

Write-Output "Done."