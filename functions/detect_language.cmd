rem Detect system locale
for /f "tokens=3" %%a in ('reg query "HKCU\Control Panel\International" /v LocaleName ^| findstr LocaleName') do set "locale=%%a"

rem Map Chinese locale variants to zh-TW or zh-CN
if /i "%locale%"=="zh-HK" set "locale=zh-TW"
if /i "%locale%"=="zh-MO" set "locale=zh-TW"
if /i "%locale:~0,7%"=="zh-Hant" set "locale=zh-TW"

if /i "%locale%"=="zh-SG" set "locale=zh-CN"
if /i "%locale%"=="zh-MY" set "locale=zh-CN"
if /i "%locale:~0,7%"=="zh-Hans" set "locale=zh-CN"

rem If locale file not exist, use en-US as default
if not exist ".\locales\%locale%.cmd" (
    set "locale=en-US"
)