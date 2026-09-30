; Text encoding must use UTF-8 BOM

; Set test mode
; !define TEST_MODE

; Basic definitions
!define APP_NAME "yd-cfe"
!define APP_EXE  "yd-cfe.cmd"
!define APP_VERSION "1.0.12"
!define APP_PUBLISHER "yd-cfe Developers"
!define APP_UNINSTKEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
!define APP_ICON "yd-cfe_icon.ico"
!define UNINST_ICON "uninstall_icon.ico"
Unicode true

; Compression settings
!ifdef TEST_MODE
    SetCompress off
!else
    SetCompressor lzma
!endif

; Installer settings
Name "${APP_NAME}"
InstallDir "$PROGRAMFILES64\${APP_NAME}"
RequestExecutionLevel admin

!ifdef TEST_MODE
    OutFile "..\release\${APP_NAME} ${APP_VERSION}-test.exe"
!else
    OutFile "..\release\${APP_NAME} ${APP_VERSION}.exe"
!endif

; Include Modern UI 2
!include "MUI2.nsh"
!include "FileFunc.nsh"
!define MUI_ICON "${APP_ICON}"
!define MUI_UNICON "${UNINST_ICON}"
!insertmacro MUI_RESERVEFILE_LANGDLL

; Welcome page
!define MUI_WELCOMEPAGE_TITLE $(LANG_Welcome_Title)
!insertmacro MUI_PAGE_WELCOME

; License, directory and installation pages
!insertmacro MUI_PAGE_LICENSE "..\LICENSE"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

; Finish page with "Create Desktop Shortcut" option
!define MUI_FINISHPAGE_SHOWREADME ""
!define MUI_FINISHPAGE_SHOWREADME_CHECKED
!define MUI_FINISHPAGE_SHOWREADME_TEXT $(LANG_CreateDesktopShortcut)
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION CreateDesktopShortcut_Function
!insertmacro MUI_PAGE_FINISH

; Uninstallation pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Language selection
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "TradChinese"
!insertmacro MUI_LANGUAGE "SimpChinese"
!define MUI_LANGDLL_ALWAYSSHOW

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function un.onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

; Welcome title language string
LangString LANG_Welcome_Title ${LANG_ENGLISH}       "Welcome to ${APP_NAME} ${APP_VERSION} Setup"
LangString LANG_Welcome_Title ${LANG_TRADCHINESE}   "歡迎使用 ${APP_NAME} ${APP_VERSION} 安裝精靈"
LangString LANG_Welcome_Title ${LANG_SIMPCHINESE}   "欢迎使用 ${APP_NAME} ${APP_VERSION} 安装程序"

; Create desktop shortcut language string
LangString LANG_CreateDesktopShortcut ${LANG_ENGLISH}       "Create desktop shortcut"
LangString LANG_CreateDesktopShortcut ${LANG_TRADCHINESE}   "建立桌面捷徑"
LangString LANG_CreateDesktopShortcut ${LANG_SIMPCHINESE}   "建立桌面快捷方式"

; Create desktop shortcut function
Function CreateDesktopShortcut_Function
    CreateShortcut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${APP_ICON}"
FunctionEnd

; Installation section
Section "Install"
    ; Remove previous installation
    RMDir /r "$INSTDIR"

    ; Set output path and copy files
    SetOutPath "$INSTDIR\bin"
    File /r "..\bin\*.*"

    SetOutPath "$INSTDIR\functions"
    File /r "..\functions\*.*"

    SetOutPath "$INSTDIR\locales"
    File /r "..\locales\*.*"

    SetOutPath "$INSTDIR"
    File "..\${APP_EXE}"
    File "${APP_ICON}"
    File "${UNINST_ICON}"

    ; Uninstall registry entries
    WriteRegStr HKLM "${APP_UNINSTKEY}" "DisplayName" "${APP_NAME}"
    WriteRegStr HKLM "${APP_UNINSTKEY}" "DisplayVersion" "${APP_VERSION}"
    WriteRegStr HKLM "${APP_UNINSTKEY}" "Publisher" "${APP_PUBLISHER}"
    WriteRegStr HKLM "${APP_UNINSTKEY}" "DisplayIcon" "$INSTDIR\${APP_ICON}"
    WriteRegStr HKLM "${APP_UNINSTKEY}" "UninstallString" '"$INSTDIR\uninstall ${APP_NAME}.exe"'
    WriteRegStr HKLM "${APP_UNINSTKEY}" "InstallLocation" "$INSTDIR"
    WriteRegDWORD HKLM "${APP_UNINSTKEY}" "NoModify" 1
    WriteRegDWORD HKLM "${APP_UNINSTKEY}" "NoRepair" 1

    ; Calculate installed size
    ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
    IntFmt $0 "0x%08X" $0
    WriteRegDWORD HKLM "${APP_UNINSTKEY}" "EstimatedSize" "$0"

    ; Create Uninstaller
    WriteUninstaller "$INSTDIR\uninstall ${APP_NAME}.exe"

    ; Create Start Menu shortcuts
    CreateDirectory "$SMPROGRAMS\${APP_NAME}"
    CreateShortcut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$INSTDIR\${APP_EXE}" "" "$INSTDIR\${APP_ICON}"
    CreateShortcut "$SMPROGRAMS\${APP_NAME}\Uninstall ${APP_NAME}.lnk" "$INSTDIR\uninstall ${APP_NAME}.exe" "" "$INSTDIR\${UNINST_ICON}"
SectionEnd

; Uninstallation section
Section "Uninstall"
  ; Remove files and shortcuts
    RMDir /r "$INSTDIR"
    RMDir /r "$SMPROGRAMS\${APP_NAME}"
    Delete "$DESKTOP\${APP_NAME}.lnk"

    ; Remove registry entries
    DeleteRegKey HKLM "${APP_UNINSTKEY}"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
SectionEnd