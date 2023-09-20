$fileList = @{
'GRMS0013.MP4' = @{ 'start' = '0.56'; 'end' = '1.12'};
'GRMS0012.MP4' = @{ 'start' = '0.00'; 'end' = '1.00'};
'GRMS0011.MP4' = @{ 'start' = '0.13'; 'end' = '1.00'};
'GRMS0009.MP4' = @{ 'start' = '1.44'; 'end' = '1.59'};
'GRMS0004.MP4' = @{ 'start' = '1.05'; 'end' = '1.32'};
}

$folder = "E:\Dashcam\6-24-23"

foreach ($file in $fileList.Keys)
{
    C:\Users\gusgr\Desktop\Active\Scripts\Trim-DashcamVideos.ps1 -File "$folder\$file" -Start $fileList[$file].start -End $fileList[$file].end
}