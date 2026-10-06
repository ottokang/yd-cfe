rem Select cookies from browser

cls
echo:
echo:
echo   %red_strong% 1 %reset_color% Brave
echo   %green_strong% 2 %reset_color% Chrome
echo   %yellow_strong% 3 %reset_color% Chromium
echo   %blue_strong% 4 %reset_color% Edge
echo   %magenta_strong% 5 %reset_color% Firefox
echo   %cyan_strong% 6 %reset_color% Opera
echo   %white_strong% 7 %reset_color% Vivaldi
echo   %red_strong% 8 %reset_color% Whale
echo:
echo   %yellow_strong% D %reset_color% %LANG_disable_cookies%
echo:
echo   %blue_strong% C %reset_color% %LANG_cancel_and_return%
echo:
echo:

choice /c 12345678dc /n /m "%LANG_select_cookies_from_prompt%"
if %errorlevel%==1 set "cookies_option=--cookies-from-browser brave" & set "cookies_from_browser=Brave"
if %errorlevel%==2 set "cookies_option=--cookies-from-browser chrome" & set "cookies_from_browser=Chrome"
if %errorlevel%==3 set "cookies_option=--cookies-from-browser chromium" & set "cookies_from_browser=Chromium"
if %errorlevel%==4 set "cookies_option=--cookies-from-browser edge" & set "cookies_from_browser=Edge"
if %errorlevel%==5 set "cookies_option=--cookies-from-browser firefox" & set "cookies_from_browser=Firefox"
if %errorlevel%==6 set "cookies_option=--cookies-from-browser opera" & set "cookies_from_browser=Opera"
if %errorlevel%==7 set "cookies_option=--cookies-from-browser vivaldi" & set "cookies_from_browser=Vivaldi"
if %errorlevel%==8 set "cookies_option=--cookies-from-browser whale" & set "cookies_from_browser=Whale"
if %errorlevel%==9 set "cookies_option=--no-cookies-from-browser" & set "cookies_from_browser="
if %errorlevel%==10 exit /b 0