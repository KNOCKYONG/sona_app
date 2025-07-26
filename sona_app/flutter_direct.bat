@echo off
echo Starting Flutter app...
cd /d "C:\Users\yong\sonaapp\sona_app"
echo Current directory: %CD%
"C:\Users\yong\Downloads\flutter_windows_3.32.7-stable\flutter\bin\flutter.bat" run -d chrome --verbose
echo Flutter command completed.