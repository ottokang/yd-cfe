rem If URL is empty, exit
if "%url%"=="" (
    echo %LANG_url_type%:
    echo:
    exit /b 0
)

rem Check if URL is a playlist or a single video, and set output file name
echo "%url%" | findstr /I /C:"list=" > nul
if %errorlevel%==0 (
    set "output_file_name=%%(playlist)s\%%(playlist_index)s. %%(title)s.%%(ext)s"
    echo %LANG_url_type%: %green_strong%%LANG_playlist%%reset_color%
) else (
    set "output_file_name=%%(title)s.%%(ext)s"
    echo %LANG_url_type%: %blue%%LANG_single_video%%reset_color%
)
echo: