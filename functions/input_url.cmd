rem Input YouTube URL

rem If in development mode, set a URL for testing
if %is_dev%==true (
    set "input_url="
    goto CHECK_INPUT_URL
)

rem Input URL prompt
cls
echo:
echo:
echo %cyan%%LANG_input_url_prompt% %reset_color% %green%
set "input_url="
set /p input_url="> "
echo %reset_color%

:CHECK_INPUT_URL
rem Check if input is empty
if "!input_url!"=="" (
    echo:
    echo %yellow%%LANG_did_not_input_url% %reset_color%
    pause
    goto INPUT_URL_END
)

rem Clean URL (symbols like &, ?...)
for /f "delims=&" %%a in ("!input_url!") do (
    set "input_url=%%a"
)
set "input_url=!input_url:?feature=shared=!"

rem Validate URL
echo %LANG_clean_url%: %yellow%"!input_url!"%reset_color%
echo:
echo %blue%%LANG_checking_url%%reset_color%
echo:

rem Get video or playlist title
set "valid_title="
for /f "delims=" %%a in ('%_YT_DLP_BIN_% %_FFMPEG_LOCATION_% %cookies_option% --encoding utf-8 --no-warnings --flat-playlist --playlist-items 1 --print "%%(playlist_title,title)s" "!input_url!"') do (
    set "valid_title=%%a"
)

if defined valid_title (
    set "title=!valid_title!"
    set "url=!input_url!"
) else (
    echo:
    echo %red%%LANG_invalid_url%%reset_color%
    pause
)

:INPUT_URL_END
exit /b 0