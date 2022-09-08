$fileList = @{
'GRMS0024.MP4' = @{ 'start' = '50'; 'end' = '1.50'};
'GRMS0026.MP4' = @{ 'start' = '5'; 'end' = '1.15'};
}

$folder = "E:\Dashcam\6-11 dashcam"

foreach ($file in $fileList.Keys)
{
    C:\Users\gusgr\Desktop\Active\Scripts\Trim-DashcamVideos.ps1 -File "$folder\$file" -Start $fileList[$file].start -End $fileList[$file].end
}