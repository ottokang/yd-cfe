rem Set echo off, root path, UTF-8 encoding, setlocal, enable delayed expansion
echo off
cd /D "%~dp0"
chcp 65001 > nul
setlocal enabledelayedexpansion

rem Set const
set "_VERSION_=1.0.11"
set "_BIN_PATH_=.\bin"
set "_YT_DLP_BIN_=%_BIN_PATH_%\yt-dlp.exe"
set "_FFMPEG_LOCATION_=--ffmpeg-location %_BIN_PATH_%"
set "_VIDEO_PARAMS_=--embed-thumbnail --embed-metadata --windows-filenames --force-overwrites --embed-subs --convert-subs srt --sub-langs all,-live_chat"
set "_AUDIO_PARAMS_=--embed-thumbnail --embed-metadata --windows-filenames --force-overwrites"

rem Load colors, initial variables
call ".\functions\colors.cmd"
set "url="
set "title="
set "output_file_name=null"
set "output_path_type=desktop"
set "output_path_type_name=null"
set "output_path=null"
set "output_path_full_name=null"
set "cookies_from_browser="
set "cookies_option=--no-cookies-from-browser"
set "locale=null"
set "is_deno_installed=false"
set "is_dev=false"

rem Set development mode
rem set "is_dev=true"

rem Check if deno is installed
call ".\functions\check_deno.cmd"

rem Detect and set system language
call ".\functions\detect_language.cmd"

rem If in development mode, goto INPUT_URL
if %is_dev%==true goto INPUT_URL

rem Menu
:MENU

rem Load langeuage file
call ".\locales\%locale%.cmd"

rem Set double quote for url and title
if "%url%"=="" (
    set "double_quote_url="
) else (
    set double_quote_url="%url%"
)

if "%title%"=="" (
    set "double_quote_title="
) else (
    set double_quote_title="%title%"
)

rem Start menu display
cls
echo:
echo     %cyan%^<^< yt-dlp-cfe ^>^>%reset_color%    v%_VERSION_%                      %yellow_strong% C %reset_color% Cookies: %green%%cookies_from_browser%%reset_color%

if "%is_deno_installed%"=="true" (
    echo:
) else (
    echo %red%%LANG_deno_not_installed%%reset_color%
)

echo %LANG_youtube_url%: %green%%double_quote_url%%reset_color%
echo:
echo %LANG_video_title%: %magenta%%double_quote_title%%reset_color%
echo:

rem Check url type (playlist or single video)
call ".\functions\check_url_type.cmd"

rem Set output folder
call ".\functions\set_output_folder.cmd"

echo:
echo     %magenta_strong% I %reset_color% %LANG_input_url%
echo:
echo:
echo     %red_strong% V %reset_color% %LANG_download_as_mp4%
echo:
echo     %green_strong% B %reset_color% %LANG_download_as_best%
echo:
echo:
echo     %yellow_strong% M %reset_color% %LANG_download_as_mp3%
echo:
echo     %blue_strong% A %reset_color% %LANG_download_as_aac%
echo:
echo:
echo     %cyan_strong% Q %reset_color% %LANG_exit%
echo:

choice /c vbmaidc0q /n /m "%LANG_please_choose%"
if %errorlevel%==1 goto MP4
if %errorlevel%==2 goto BEST_VIDEO
if %errorlevel%==3 goto MP3
if %errorlevel%==4 goto AAC
if %errorlevel%==5 goto INPUT_URL
if %errorlevel%==6 goto SWITCH_OUTPUT_PATH
if %errorlevel%==7 goto SELECT_COOKIES_FROM_BROWSER
if %errorlevel%==8 goto REFRESH_MENU
if %errorlevel%==9 goto END

rem Download as MP4
:MP4
if "%url%"=="" (
    call ".\functions\alert_url_is_empty.cmd"
    goto MENU
)

echo:
choice /n /m "%LANG_do_you_want_to_continue%%red_strong%%LANG_download_as_mp4%%reset_color%%bold%%LANG_will_overwrite%%reset_color%? [%green%Y%reset_color%, %red%N%reset_color%]"
if %errorlevel%==1 (
    cls
    %_YT_DLP_BIN_% --output %output_path_full_name% %_FFMPEG_LOCATION_% %cookies_option% %_VIDEO_PARAMS_% -t mp4 %url%
    goto DOWNLOAD_COMPLETE
)
goto MENU

rem Download as Best Video
:BEST_VIDEO
if "%url%"=="" (
    call ".\functions\alert_url_is_empty.cmd"
    goto MENU
)

echo:
choice /n /m "%LANG_do_you_want_to_continue%%green_strong%%LANG_download_as_best%%reset_color%%bold%%LANG_will_overwrite%%reset_color%? [%green%Y%reset_color%, %red%N%reset_color%]"
if !ERRORLEVEL!==1 (
    cls
    %_YT_DLP_BIN_% --output %output_path_full_name% %_FFMPEG_LOCATION_% %cookies_option% %_VIDEO_PARAMS_% -f "bestvideo+bestaudio/best" --merge-output-format mkv %url%
    goto DOWNLOAD_COMPLETE
)
goto MENU

rem Download as MP3
:MP3
if "%url%"=="" (
    call ".\functions\alert_url_is_empty.cmd"
    goto MENU
)

echo:
choice /n /m "%LANG_do_you_want_to_continue%%yellow_strong%%LANG_download_as_mp3%%reset_color%%bold%%LANG_will_overwrite%%reset_color%? [%green%Y%reset_color%, %red%N%reset_color%]"
if !ERRORLEVEL!==1 (
    cls
    %_YT_DLP_BIN_% --output %output_path_full_name% %_FFMPEG_LOCATION_% %cookies_option% %_AUDIO_PARAMS_% -t mp3 %url%
    goto DOWNLOAD_COMPLETE
)
goto MENU

rem Download as AAC
:AAC
if "%url%"=="" (
    call ".\functions\alert_url_is_empty.cmd"
    goto MENU
)

echo:
choice /n /m "%LANG_do_you_want_to_continue%%blue_strong%%LANG_download_as_aac%%reset_color%%bold%%LANG_will_overwrite%%reset_color%? [%green%Y%reset_color%, %red%N%reset_color%]"
if !ERRORLEVEL!==1 (
    cls
    %_YT_DLP_BIN_% --output %output_path_full_name% %_FFMPEG_LOCATION_% %cookies_option% %_AUDIO_PARAMS_% -t aac %url%
    goto DOWNLOAD_COMPLETE
)
goto MENU

rem Download complete
:DOWNLOAD_COMPLETE
echo:
echo %cyan% %LANG_download_complete% %reset_color%
pause
goto MENU

rem Input url
:INPUT_URL
call ".\functions\input_url.cmd"
goto MENU

rem Switch output folder
:SWITCH_OUTPUT_PATH
if %output_path_type%==desktop (
    set output_path_type=downloads
) else (
    set output_path_type=desktop
)
goto MENU

rem Select cookies from browser
:SELECT_COOKIES_FROM_BROWSER
call ".\functions\select_cookies_from_browser.cmd"
goto MENU

rem Refresh
:REFRESH_MENU
goto MENU

rem Quit
:END
echo:
choice /n /m "%lang_do_you_want_end%? [%green%Y%reset_color%, %red%N%reset_color%]"
if !ERRORLEVEL!==1 (
    exit /b 0
)
goto MENU