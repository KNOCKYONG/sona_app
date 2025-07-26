@echo off
REM Process Persona Image Batch Script

echo =======================================
echo  Sona App - Persona Image Processor
echo =======================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.8 or higher
    pause
    exit /b 1
)

REM Check if required packages are installed
python -c "import PIL" >nul 2>&1
if errorlevel 1 (
    echo Installing required packages...
    pip install Pillow boto3
)

REM Process the image locally first
echo Processing image locally...
python scripts\process_persona_image.py "C:\Users\yong\Downloads\윤미1.png" --persona "윤미" --output "."

echo.
echo =======================================
echo Local processing complete!
echo.
echo To upload to Cloudflare R2:
echo 1. Copy config\r2_config_template.json to config\r2_config.json
echo 2. Fill in your Cloudflare R2 credentials
echo 3. Run: python scripts\upload_persona_to_r2.py "C:\Users\yong\Downloads\윤미1.png" --persona "윤미" --config config\r2_config.json
echo =======================================
echo.
pause