# PowerShell script to rename Korean persona folders to English
# Run from the sonaapp directory

$baseDir = "C:\Users\yong\sonaapp\assets\personas"

# Define the mapping
$folderMapping = @{
    "나연" = "nayeon"
    "동현" = "donghyun"
    "미연" = "miyeon"
    "민수" = "minsu"
    "민준" = "minjun"
    "박준영" = "park-junyoung"
    "성호" = "seongho"
    "세빈" = "sebin"
    "소희" = "sohee"
    "영훈" = "younghoon"
    "재성" = "jaesung"
    "재현" = "jaehyun"
    "종호" = "jongho"
    "준영" = "junyoung"
    "준호" = "junho"
    "진욱" = "jinwook"
    "효진" = "hyojin"
}

Write-Host "Starting folder renaming process..." -ForegroundColor Green
Write-Host "Base directory: $baseDir" -ForegroundColor Yellow
Write-Host "-" * 50

$renamed = 0
$failed = 0

foreach ($korean in $folderMapping.Keys) {
    $english = $folderMapping[$korean]
    $oldPath = Join-Path $baseDir $korean
    $newPath = Join-Path $baseDir $english
    
    if (Test-Path $oldPath) {
        try {
            # Check if target already exists
            if (Test-Path $newPath) {
                Write-Host "WARNING: Target folder already exists: $english" -ForegroundColor Yellow
                continue
            }
            
            # Rename the folder
            Rename-Item -Path $oldPath -NewName $english -ErrorAction Stop
            Write-Host "✓ Renamed: $korean → $english" -ForegroundColor Green
            $renamed++
        }
        catch {
            Write-Host "✗ Failed to rename: $korean → $english" -ForegroundColor Red
            Write-Host "  Error: $_" -ForegroundColor Red
            $failed++
        }
    }
    else {
        Write-Host "- Folder not found: $korean (skipping)" -ForegroundColor Gray
    }
}

Write-Host "-" * 50
Write-Host "Renaming complete!" -ForegroundColor Green
Write-Host "Successfully renamed: $renamed folders" -ForegroundColor Green
if ($failed -gt 0) {
    Write-Host "Failed: $failed folders" -ForegroundColor Red
}