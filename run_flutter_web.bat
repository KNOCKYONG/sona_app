@echo off
set PATH=C:\Windows\System32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files\Git\cmd;%PATH%
cd /d "C:\Users\노용석\sonaapp\sona_app\sona_app"
"C:\Users\노용석\sonaapp\sona_app\flutter\bin\flutter.bat" build web --release --web-renderer html
echo.
echo Build completed. Opening in Chrome...
start chrome "file:///%CD%/build/web/index.html"
pause