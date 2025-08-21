@echo off
set PATH=C:\Program Files\Git\cmd;C:\Program Files\Git\mingw64\bin;C:\Windows\System32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;%PATH%
cd /d "C:\Users\노용석\sonaapp\sona_app\sona_app"
echo Starting Flutter in Chrome...
"C:\Users\노용석\sonaapp\sona_app\flutter\bin\flutter.bat" run -d chrome