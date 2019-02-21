;--------------------------------
;Include Modern UI

!include "MUI.nsh"

;--------------------------------
;General

!define VERSION "2.2.3"
!define NAME "OCS"
!define /date CDATE "%b %d %Y at %H:%M:%S"


Name "${NAME} Windows Agent v${VERSION}"
OutFile "ocs-agent-alienvault-installer.exe"


InstallDir "$PROGRAMFILES\OCS Inventory Agent"


;--------------------------------
;Interface Settings

!define MUI_ABORTWARNING

;--------------------------------
;Pages
  !define MUI_ICON ../favicon.ico
  !define MUI_UNICON ../favicon.ico



  !insertmacro MUI_PAGE_INSTFILES

  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"

;--------------------------------

;Function .onInstSuccess
;  Delete "$DESKTOP\OcsAgentSetup.txt"
;FunctionEnd

Section "OCS Agent (required)" MainSec

;Required section.
SectionIn RO
SetOutPath $INSTDIR

ClearErrors

File OcsAgentSetup.exe
WriteUninstaller "uninstall.exe"


; Writing version and install information
;FileOpen $0 $INSTDIR\VERSION.txt w
;IfErrors done
;FileWrite $0 "${NAME} v${VERSION} - "
;FileWrite $0 "Installed on ${CDATE}"
;FileClose $0
;done:


; Install in the services 
Exec '"OcsAgentSetup.exe" "/S /server:192.168.1.21 /np /FORCE /NOW"'


Quit
SectionEnd

Section "Uninstall"

ExecWait '"$INSTDIR\uninst.exe" /S _?=$INSTDIR''
Quit
  
  ; Stop ossec
;  ExecWait '"net" "stop" "OssecSvc"'
  
  ; Uninstall from the services
;  Exec '"$INSTDIR\ossec-agent.exe" uninstall-service'

  ; Remove registry keys

  ; Remove files and uninstaller
;  Delete "$INSTDIR"

;  RMDir "$INSTDIR"

SectionEnd
