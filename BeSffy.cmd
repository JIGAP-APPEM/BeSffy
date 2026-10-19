@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem ============================================================
rem  BeSffy - Best SFF Optimizer   (Made by Jigap-Appem)
rem  License: MIT. Copyright (c) 2026 Jigap-Appem. The full license text is below the "exit /b" line.
rem  Double-click to open the menu (asks for administrator permission).
rem  Korean notes are below the "exit /b" line. cmd.exe never reads past it,
rem  and the lines above must stay plain ASCII: cmd.exe reads batch files in
rem  the console code page, so Korean text here would break the lines after it.
rem  On-screen messages are the "rem MSG-..." lines down there; BESFFY_SAY prints them.
rem ============================================================
set "BESFFY_SELF=%~f0"
rem Always use the 64-bit Windows tools, even when this file was opened from a 32-bit program.
rem 32-bit PowerShell would write registry and system settings to the 32-bit copies.
set "BESFFY_SYS=%SystemRoot%\System32"
if exist "%SystemRoot%\Sysnative\cmd.exe" set "BESFFY_SYS=%SystemRoot%\Sysnative"
set "BESFFY_POSH=%BESFFY_SYS%\WindowsPowerShell\v1.0\powershell.exe"
set "BESFFY_SAY=foreach($l in [IO.File]::ReadAllLines($env:BESFFY_SELF,[Text.Encoding]::UTF8)){if($l.StartsWith('rem '+$env:BESFFY_KEY+' ')){Write-Host ('  '+$l.Substring($env:BESFFY_KEY.Length+5)) -ForegroundColor Yellow}}"
rem Administrator check: fltmc works even when the Server service is turned off, net session does not.
rem If fltmc fails for another reason, PowerShell checks again.
set "BESFFY_ADMIN="
"%BESFFY_SYS%\fltmc.exe" >nul 2>&1
if %errorlevel% EQU 0 set "BESFFY_ADMIN=1"
if not defined BESFFY_ADMIN "%BESFFY_POSH%" -NoProfile -Command "if(([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){exit 0};exit 1" >nul 2>&1
if not defined BESFFY_ADMIN if %errorlevel% EQU 0 set "BESFFY_ADMIN=1"
rem Not administrator: reopen as administrator through cmd.exe, not this file directly.
rem The reopened copy gets /besffy-elevated, so if it is still not administrator it stops instead of asking forever.
if not defined BESFFY_ADMIN if /i "%~1"=="/besffy-elevated" (
  set "BESFFY_KEY=MSG-NOADMIN"
  "%BESFFY_POSH%" -NoProfile -Command "%BESFFY_SAY%"
  pause
  exit /b 1
)
if not defined BESFFY_ADMIN (
  "%BESFFY_POSH%" -NoProfile -Command "$a='/c '+[char]34+[char]34+$env:BESFFY_SELF+[char]34+' /besffy-elevated'+[char]34; try{Start-Process -Verb RunAs -FilePath ($env:SystemRoot+'\System32\cmd.exe') -ArgumentList $a -ErrorAction Stop}catch{exit 1}" >nul 2>&1
  if errorlevel 1 (
    set "BESFFY_KEY=MSG-UAC"
    "%BESFFY_POSH%" -NoProfile -Command "%BESFFY_SAY%"
    pause
  )
  exit /b
)
rem Copy the program below the marker line to a temporary .ps1 file and run it.
set "BESFFY_HOME=%~dp0"
set "BESFFY_PS=%TEMP%\BeSffy_%RANDOM%%RANDOM%.ps1"
"%BESFFY_POSH%" -NoProfile -ExecutionPolicy Bypass -Command ^
  "try{Unblock-File -LiteralPath $env:BESFFY_SELF -ErrorAction Stop}catch{};" ^
  "$f=[IO.File]::ReadAllText($env:BESFFY_SELF,[Text.Encoding]::UTF8);" ^
  "$m='#@'+'BESFFY_PAYLOAD'+'@';" ^
  "$i=$f.IndexOf($m);" ^
  "if($i -lt 0){exit 1};" ^
  "$ps=$f.Substring($i+$m.Length).TrimStart([char]13,[char]10);" ^
  "[IO.File]::WriteAllText($env:BESFFY_PS,$ps,(New-Object Text.UTF8Encoding $true))"
if not exist "%BESFFY_PS%" (
  set "BESFFY_KEY=MSG-PREP"
  "%BESFFY_POSH%" -NoProfile -Command "%BESFFY_SAY%"
  pause
  exit /b 1
)
"%BESFFY_POSH%" -NoProfile -ExecutionPolicy Bypass -File "%BESFFY_PS%"
rem If the program stopped with an error, keep the window open so the message can be read.
if errorlevel 1 pause
del "%BESFFY_PS%" >nul 2>&1
exit /b
rem ------------------------------------------------------------
rem  [안내] 여기부터는 명령 프롬프트가 읽지 않아요. 메모장으로 보는 분을 위한 설명이에요.
rem  BeSffy - Best SFF Optimizer (Made by Jigap-Appem)
rem  - 이 파일 하나만 있으면 돼요. 더블클릭하면 관리자 권한을 물어본 뒤 메뉴가 열려요.
rem  - 위쪽 몇 줄이 하는 일:
rem    1) 32비트 프로그램에서 열려도 항상 64비트 Windows 도구(PowerShell 등)를 써요.
rem    2) 관리자 권한인지 확인하고, 아니면 관리자 권한으로 다시 열어요 (한 번만 물어봐요).
rem       다시 열 때는 이 파일을 직접 열지 않고 cmd.exe 로 실행해요
rem       (인터넷에서 받은 파일을 직접 열면 스마트 앱 컨트롤·SmartScreen 이 또 막을 수 있어서).
rem    3) 아래 표시 줄 다음의 프로그램(PowerShell) 내용을 임시 폴더에 꺼내 실행하고, 끝나면 지워요.
rem       프로그램이 오류로 멈추면 창을 바로 닫지 않고 기다려서 오류 내용을 읽을 수 있게 해요.
rem  - 한 번 열리면 이 파일에 붙은 "인터넷에서 받은 파일" 표시를 지워서, 다음부터는 더블클릭으로 바로 열려요.
rem  - 더블클릭이 막히면: 파일 우클릭, 속성, 아래쪽 차단 해제 체크, 확인.
rem  - 보고서·백업·선택값은 이 파일이 있는 폴더에 생겨요.
rem
rem  [화면 안내문] 위쪽에서 문제가 생기면 아래 줄의 글을 화면에 띄워요 (BESFFY_SAY).
rem MSG-UAC 관리자 권한이 필요해요. 다시 더블클릭한 뒤, 권한을 묻는 창에서 '예'를 눌러 주세요.
rem MSG-NOADMIN 관리자 권한으로 열지 못했어요. 파일을 마우스 오른쪽 버튼으로 눌러 '관리자 권한으로 실행'을 골라 주세요.
rem MSG-PREP 프로그램을 준비하지 못했어요. 파일이 깨졌을 수 있으니 다시 받아 보고, 백신 프로그램이 임시 폴더(TEMP)를 막았는지도 확인해 주세요.
rem ------------------------------------------------------------
rem  [라이선스] BeSffy 는 MIT 라이선스로 배포해요. 아래 저작권 표시와 허가 문구를 지우지 말고 함께 배포해 주세요.
rem
rem  MIT License
rem
rem  Copyright (c) 2026 Jigap-Appem
rem
rem  Permission is hereby granted, free of charge, to any person obtaining a copy
rem  of this software and associated documentation files (the "Software"), to deal
rem  in the Software without restriction, including without limitation the rights
rem  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
rem  copies of the Software, and to permit persons to whom the Software is
rem  furnished to do so, subject to the following conditions:
rem
rem  The above copyright notice and this permission notice shall be included in all
rem  copies or substantial portions of the Software.
rem
rem  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
rem  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
rem  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
rem  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
rem  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
rem  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
rem  SOFTWARE.
rem ------------------------------------------------------------
#@BESFFY_PAYLOAD@
<#
  BeSffy (Best SFF Optimizer) - Made by Jigap-Appem
  License: MIT (Copyright (c) 2026 Jigap-Appem). 전문은 BeSffy.cmd 아래쪽 또는 LICENSE 파일.
  - Lite26H2 설정을 지금 쓰고 있는 PC 에 적용 (다시 설치하지 않고)
  - 빌드(Build-Lite26H2.ps1)가 설치 이미지에 넣는 설정을, 실행 중인 Windows 에 맞게 옮긴 것입니다.
  - 사용법 (관리자 권한, Windows PowerShell 5.1. PowerShell 7 에서 열면 5.1 로 다시 열어요):
      메뉴 1 미리보기 : 아무것도 바꾸지 않고 현재 상태와 바뀔 내용을 보고서로 저장 (지울 앱도 여기서 고름)
      메뉴 2 적용     : 복원 지점 + 백업을 만든 뒤 적용
      메뉴 4 되돌리기 : 적용 때 바꾼 레지스트리·서비스·업데이트 잠금·터미널·바로가기·예약된 저장소를 되돌림
                      (여러 번 적용했으면 최근 것부터 차례로 되돌려 맨 처음 적용 전 상태로)
                      (지운 앱·구성요소·OneDrive 는 되돌리지 않음: 스토어·선택적 기능·복원 지점으로)
      메뉴 3 점검     : 적용한 뒤 지금 상태가 맞는지 점검만 (아무것도 바꾸지 않음, 앱 고르는 창 없음)
      메뉴 5 일부 옵션만 복구 : 백그라운드가 막힌 스토어 앱을 골라서 다시 허용 (프로그램별로 묶어 보여 줌), 검색 색인 다시 켜기, 시작 프로그램 다시 켜기
  - 설치 때만 의미 있는 것(로컬 계정·첫 세팅 화면, TPM 우회, 새 사용자 시작 메뉴·테마, 이미지 압축)은 뺐습니다.
  - 실행 중인 PC 에 그대로 쓰면 곤란한 빌드 항목은 바꿔서 적용합니다:
      · 시작 메뉴 고정 앱 비우기(ConfigureStartPins) → 뺌 (지금 고정해 둔 앱이 사라지므로)
      · 사용자 Run 키 통째 삭제 → OneDrive 항목만 지움 (다른 시작 프로그램은 그대로)
#>
param(
    [ValidateSet('Menu', 'Preview', 'Apply', 'Undo', 'Check', 'Background', 'Search', 'Restore')]
    [string]$Mode = 'Menu'
)

# ============================== 이 PC 에 적용할 것 (사용자 선택) ==============================
$Do = [ordered]@{
    Apps             = $true    # 앱 삭제 (미리보기에서 하나씩 고른 것만)
    SystemComponents = $true    # IE 구성요소, 옛 Windows Media Player, PowerShell ISE, 단계 레코더, 수학 입력판, Recall
    Settings         = $true    # 광고·추천·AI·원격 분석 끄기, Edge·앱 백그라운드 끄기, 탐색기 설정 등
    Startup          = $true    # 시작 프로그램 정리 (미리보기에서 고른 것만 켜고 끔. 작업 관리자 '시작 앱'과 같은 방식)
    DefenderScan     = $false   # Defender 예약 검사가 CPU 를 평균 20% 까지만 쓰게 (실시간 보호는 그대로). 효과가 PC 마다 달라 기본은 끔 (고르는 창의 검사 기록을 보고 켬)
    UpdateLock       = $true    # 2046년까지 일시정지 + 매일 다시 잠금, 바탕화면 켜기/끄기, 현재 버전 고정
    OneDrive         = $true    # OneDrive 제거 (PC·클라우드의 파일은 지우지 않음)
    DisableSearch    = $true    # 검색 색인(WSearch) 끄기
    DarkMode         = $false   # 다크 모드 (이 PC 는 밝은 모드 그대로 쓰기로 함)
}
# 스토어 앱 백그라운드 금지의 예외 (휴대폰과 연결은 항상 예외). 미리보기·메뉴 5 에서 창으로 고름.
# 아래에 맞는 앱은 '추천(★)'으로 미리 체크됨: 꺼 두면 동기화·알림·공유가 안 될 수 있는 앱 (아무 PC 용 기본값)
$BgRecommend = [ordered]@{
    '클라우드·동기화'      = @('AppleInc.*', '*iCloud*', '*Cloud*', '*Sync*', '*Dropbox*', '*OneDrive*', '*GoogleDrive*', '*Backup*', '*StickyNotes*')
    '휴대폰 연동·공유'     = @('*QuickShare*', '*NearbyShare*', '*Continuity*', '*PhoneLink*', 'SAMSUNGELECTRONICSCO*', 'SAMSUNGELECTRONICS*')
    '메신저·메일'          = @('*WhatsApp*', '*Telegram*', 'FACEBOOK.*', '*Messenger*', 'MSTeams', '*Teams*', 'Microsoft.OutlookForWindows',
                               'microsoft.windowscommunicationsapps', '*Skype*', '*Zoom*', '*Slack*', '*Discord*', 'NAVER.LINE*', '*Kakao*', '*Signal*')
    '오디오·그래픽·제조사' = @('SenaryTechnologyLimited.*', 'RealtekSemiconductorCorp.*', 'WavesAudio.*', 'DolbyLaboratories.*',
                               '*MaxxAudio*', '*Nahimic*', '*SmartAudio*', '*DTS*',
                               'NVIDIACorp.*', '*GeForce*', 'AdvancedMicroDevicesInc*', '*RadeonSoftware*', 'IntelCorporation*', '*IntelGraphics*', 'AppUp.Intel*',
                               '*DellInc*', 'DellInc.*', '*MyDell*', '*LenovoVantage*', '*Lenovo*', 'E046963F.*', 'AD2F1837.*', '*HPSystemInformation*', '*myHP*',
                               'B9ECED6F.*', '*ArmouryCrate*', '*MyASUS*', '*ASUS*', '*MSICenter*', '*GigabyteControlCenter*',
                               '*Alienware*', '*GamingHub*', '*ControlCenter*')
}
$BackgroundAllow = @($BgRecommend.Values | ForEach-Object { $_ })
# 고르는 창에서 묶어 보여 줄 프로그램 (패키지 이름 패턴 → 프로그램 이름). 위에서부터 먼저 맞는 것
$BgVendors = @(
    @('AppleInc.*', 'Apple (iCloud 등)'), @('SAMSUNGELECTRONICS*', '삼성 (Samsung)'),
    @('SenaryTechnologyLimited.*', 'Senary 오디오'), @('RealtekSemiconductorCorp.*', 'Realtek 오디오'), @('WavesAudio.*', 'Waves 오디오'),
    @('DolbyLaboratories.*', 'Dolby 오디오'), @('NVIDIACorp.*', 'NVIDIA 그래픽'), @('AdvancedMicroDevicesInc*', 'AMD 그래픽'),
    @('AppUp.Intel*', 'Intel 그래픽'), @('IntelCorporation*', 'Intel'), @('DellInc*', 'Dell'), @('E046963F.*', 'Lenovo'), @('*Lenovo*', 'Lenovo'),
    @('AD2F1837.*', 'HP'), @('B9ECED6F.*', 'ASUS'), @('*ASUS*', 'ASUS'),
    @('5319275A.*', 'WhatsApp'), @('FACEBOOK.*', 'Meta (Messenger·Instagram)'), @('TelegramMessengerLLP.*', 'Telegram'),
    @('SpotifyAB.*', 'Spotify'), @('C27EB4BA.*', 'Dropbox'), @('4DF9E0F8.*', 'Netflix'), @('Disney.*', 'Disney+'), @('Google*', 'Google'),
    @('Microsoft.Xbox*', 'Xbox'), @('Microsoft.Gaming*', 'Xbox'), @('MicrosoftWindows.*', 'Windows 구성요소'),
    @('Microsoft.*', 'Microsoft 앱'), @('MicrosoftCorporationII.*', 'Microsoft 앱'), @('MSTeams', 'Microsoft 앱'), @('Clipchamp.*', 'Microsoft 앱')
)
# 이름만 봐서는 뭔지 모르는 패키지의 알기 쉬운 이름 (패턴 → 이름). 없으면 앱 목록·시작 메뉴 이름, 그것도 없으면 패키지 이름을 풀어 씀
$BgLabels = @(
    @('AppleInc.iCloud', 'iCloud (사진·iCloud Drive·암호 동기화)'), @('AppleInc.AppleDevices', 'Apple 기기 (아이폰 백업·동기화)'),
    @('AppleInc.AppleMusicWin', 'Apple Music'), @('AppleInc.AppleTVWin', 'Apple TV'), @('AppleInc.iTunes', 'iTunes'),
    @('*QuickShare*', 'Quick Share (퀵쉐어, 휴대폰과 파일 주고받기)'), @('*NearbyShare*', 'Nearby Share (파일 주고받기)'),
    @('SAMSUNGELECTRONICSCoLtd.SamsungContinuityService', 'Samsung 연속성 서비스 (휴대폰 연동)'),
    @('*KnoxMatrixforWindows', 'Knox Matrix (삼성 기기 보안 연동)'), @('*SamsungAccountPluginforSa', 'Samsung 계정 플러그인'),
    @('*SamsungAccount', 'Samsung 계정'), @('*SamsungCloudBluetoothSync', 'Samsung Cloud 블루투스 동기화'),
    @('*SamsungCloudPlatformManag', 'Samsung Cloud 플랫폼 관리자'), @('*SamsungIntelligenceVoiceS', 'Samsung 음성 서비스'),
    @('*SamsungPass', 'Samsung Pass (암호·로그인)'), @('*SamsungSettingsRuntime', 'Samsung Settings 런타임'), @('*SamsungSettings*', 'Samsung Settings'),
    @('*SamsungWelcome', 'Samsung Welcome'), @('*SmartSelect', 'Smart Select (화면 캡처)'), @('*SmartThingsWindows', 'SmartThings'),
    @('*SamsungNotes', 'Samsung Notes'), @('*SamsungGallery*', 'Samsung 갤러리'), @('*SamsungFlow*', 'Samsung Flow (휴대폰 연동)'),
    @('SenaryTechnologyLimited.SenarySmartAudio', 'Senary 스마트 오디오 (사운드 설정)'), @('RealtekSemiconductorCorp.RealtekAudioControl', 'Realtek 오디오 콘솔'),
    @('NVIDIACorp.NVIDIAControlPanel', 'NVIDIA 제어판'), @('AppUp.IntelGraphicsExperience', 'Intel 그래픽 사령 센터'),
    @('AdvancedMicroDevicesInc*RadeonSoftware*', 'AMD Radeon 소프트웨어'), @('DolbyLaboratories.DolbyAccess', 'Dolby Access'),
    @('5319275A.WhatsAppDesktop', 'WhatsApp'), @('TelegramMessengerLLP.TelegramDesktop', 'Telegram'), @('C27EB4BA.Dropbox*', 'Dropbox'),
    @('Microsoft.Windows.Photos', '사진'), @('Microsoft.WindowsCalculator', '계산기'), @('Microsoft.WindowsNotepad', '메모장'),
    @('Microsoft.ScreenSketch', '캡처 도구'), @('Microsoft.WindowsTerminal', '터미널'), @('Microsoft.PowerShell', 'PowerShell 7'),
    @('Microsoft.Xbox.TCUI', 'Xbox 로그인 화면'), @('Microsoft.Winget.Source', 'winget 앱 목록 (앱 설치 도구)'),
    @('Microsoft.ApplicationCompatibilityEnhancements', '앱 호환성 개선'), @('MicrosoftCorporationII.WinAppRuntime*', 'Windows 앱 런타임'),
    @('Microsoft.ZuneMusic', '미디어 플레이어'), @('Microsoft.WindowsCamera', '카메라'), @('Microsoft.Paint', '그림판'),
    @('Microsoft.MicrosoftStickyNotes', '스티커 메모 (동기화)'), @('Microsoft.MicrosoftPCManager', 'PC Manager'),
    @('Microsoft.OutlookForWindows', 'Outlook (메일·일정 알림)'), @('MSTeams', 'Teams (채팅 알림)'), @('Microsoft.Todos', 'Microsoft To Do (동기화·알림)')
)
# ==========================================================================================

$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'
$AppName      = 'BeSffy'                # 프로그램 이름 (Best SFF Optimizer)
$Credit       = 'Made by Jigap-Appem'
# 단일 .cmd 로 배포할 때는 엔진이 임시 폴더에서 돌아서, 보고서·백업·선택값을 둘 폴더를 BESFFY_HOME 으로 받음
$Here         = if ($env:BESFFY_HOME) { $env:BESFFY_HOME } else { $PSScriptRoot }
$DefHive      = 'BeSffyDefaultUser'     # 새 사용자 기본값(NTUSER.DAT)을 잠깐 불러올 이름 (HKEY_USERS 아래)
$TaskPath     = '\BeSffy\'
$TaskName     = 'WU-RePause'
$FlagKey      = 'SOFTWARE\BeSffy'       # 업데이트 켜기/끄기 상태를 적는 레지스트리 키 (HKLM)
# 예전(LiteTools) 이름으로 적용해 둔 PC 도 되돌리기 때 같이 정리하려고 보관
$TaskPathOld  = '\LiteTools\'
$ToolsDirName = 'BeSffy'                # ProgramData 아래 도구 폴더 이름
$PauseEnd     = '2046-01-01T00:00:00Z'
$ToolFiles    = @('WU-Pause.ps1', 'WU-On.ps1', 'WU-Off.ps1')
$WuLinks      = [ordered]@{ 'Windows 업데이트 켜기.lnk' = 'WU-On.ps1'; 'Windows 업데이트 끄기.lnk' = 'WU-Off.ps1' }
$TerminalPkg  = 'Microsoft.WindowsTerminal_8wekyb3d8bbwe'
$ProfileNames = @{ '{574e775e-4f2a-5b96-ac1e-a2962a402336}' = 'PowerShell 7'; '{61c54bbd-c2c6-5271-96e7-009a87ff44bf}' = 'Windows PowerShell 5.1'
                   '{0caa0dad-35be-5f56-a8ff-afceeeaa6101}' = '명령 프롬프트' }
$ProfilePwsh  = '{574e775e-4f2a-5b96-ac1e-a2962a402336}'
$ProfileWinPS = '{61c54bbd-c2c6-5271-96e7-009a87ff44bf}'
$HKLM = 'HKEY_LOCAL_MACHINE'

$script:Out  = New-Object System.Collections.Generic.List[string]
$script:Warn = New-Object System.Collections.Generic.List[string]
function Say([string]$t)  { Write-Host $t; $script:Out.Add($t) }
function Head([string]$t) { Write-Host "`n==== $t ====" -ForegroundColor Cyan; $script:Out.Add(''); $script:Out.Add("==== $t ====") }
function Warn([string]$t) { Write-Host "  [주의] $t" -ForegroundColor Yellow; $script:Out.Add("  [주의] $t"); $script:Warn.Add($t) }
function YesNo($b) { if ($b) { '예' } else { '아니요' } }

# ============================== 시스템 접근 ==============================
# Windows 에 직접 닿는 부분은 여기 함수들로만 (점검용 모의 실행에서 이 함수들만 바꿔 끼워 전체 흐름을 시험함)
function Ask([string]$q) { $a = Read-Host "$q (Y/N)"; return ($a -match '^\s*[Yy]') }
function New-Stamp { Get-Date -Format 'yyyyMMdd_HHmmss' }
function Get-CurrentUserName { [Security.Principal.WindowsIdentity]::GetCurrent().Name }
function Get-ExplorerUser {
    try {
        $e = Get-CimInstance Win32_Process -Filter "Name='explorer.exe'" | Select-Object -First 1
        if ($e) { $o = Invoke-CimMethod -InputObject $e -MethodName GetOwner; return "$($o.Domain)\$($o.User)" }
    } catch {}
    return $null
}
# .NET 파일 함수는 PowerShell 의 현재 위치를 모르므로 항상 전체 경로로 바꿔서 씀
function Get-FsPath([string]$p) { $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($p) }
function Write-TextFile([string]$path, [string]$text, [string]$enc = 'utf8bom') {
    $e = switch ($enc) { 'utf16' { [Text.Encoding]::Unicode } 'utf8' { New-Object Text.UTF8Encoding($false) } default { New-Object Text.UTF8Encoding($true) } }
    [IO.File]::WriteAllText((Get-FsPath $path), $text, $e)
}
function Read-TextFile([string]$path) { [IO.File]::ReadAllText((Get-FsPath $path)) }   # BOM 으로 인코딩 자동 판단 (없으면 UTF-8)

# 외부 프로그램 실행 (PowerShell 5.1 에서 오류 출력 때문에 멈추지 않도록)
function Invoke-Native([string]$exe, [string[]]$argList) {
    $ErrorActionPreference = 'Continue'
    $o = & $exe @argList 2>&1 | ForEach-Object { "$_" }
    [pscustomobject]@{ Code = $LASTEXITCODE; Text = (($o | Where-Object { $_ }) -join ' ').Trim() }
}

# ---- 레지스트리 (.NET 으로 직접) ----
function Get-RegBase([string]$root) {
    if ($root -eq 'HKEY_LOCAL_MACHINE') { return [Microsoft.Win32.Registry]::LocalMachine, '' }
    if ($root -eq 'HKEY_CURRENT_USER')  { return [Microsoft.Win32.Registry]::CurrentUser, '' }
    if ($root -like 'HKEY_USERS\*')     { return [Microsoft.Win32.Registry]::Users, ($root.Substring(11) + '\') }
    throw "알 수 없는 레지스트리 위치: $root"
}
function New-RegResult([bool]$keyExists, [bool]$exists, $kind, $value, $err) {
    [pscustomobject]@{ KeyExists = $keyExists; Exists = $exists; Kind = $kind; Value = $value; Error = $err }
}
# 반환: KeyExists(키 있음) / Exists(값 있음) / Kind(DWord·String·MultiString…) / Value / Error(읽기 실패 이유)
function Get-RegValue([string]$root, [string]$key, [string]$name) {
    $k = $null
    try {
        $base, $pre = Get-RegBase $root
        $k = $base.OpenSubKey($pre + $key, $false)
        if (-not $k) { return New-RegResult $false $false $null $null $null }
        if ($k.GetValueNames() -notcontains $name) { return New-RegResult $true $false $null $null $null }
        $kind = "$($k.GetValueKind($name))"
        $val  = $k.GetValue($name, $null, [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames)
        return New-RegResult $true $true $kind $val $null
    } catch {
        return New-RegResult $false $false $null $null $_.Exception.Message
    } finally { if ($k) { $k.Close() } }
}
# 키 안의 값 이름들 (키가 없으면 아무것도 안 내보냄)
function Get-RegValueNames([string]$root, [string]$key) {
    $k = $null
    try {
        $base, $pre = Get-RegBase $root
        $k = $base.OpenSubKey($pre + $key, $false)
        if ($k) { $k.GetValueNames() }   # 하나씩 내보냄 (부르는 쪽에서 @() 로 받음)
    } catch {} finally { if ($k) { $k.Close() } }
}
function Set-RegDirect([string]$root, [string]$key, [string]$name, [string]$kind, $value) {
    $base, $pre = Get-RegBase $root
    $k = $base.CreateSubKey($pre + $key)
    try {
        $v = switch ($kind) {
            'DWord'       { [BitConverter]::ToInt32([BitConverter]::GetBytes([uint32]([int64]$value -band 4294967295)), 0) }
            'QWord'       { [int64]$value }
            'MultiString' { ,[string[]]@($value) }   # 쉼표: switch 가 배열을 펼치지 않게
            'Binary'      { ,[byte[]]$value }
            default       { [string]$value }
        }
        $k.SetValue($name, $v, [Microsoft.Win32.RegistryValueKind]$kind)
    } finally { $k.Close() }
}
function Remove-RegValueDirect([string]$root, [string]$key, [string]$name) {
    $base, $pre = Get-RegBase $root
    $k = $base.OpenSubKey($pre + $key, $true)
    if ($k) { try { $k.DeleteValue($name, $false) } finally { $k.Close() } }
}
# 값도 하위 키도 없을 때만 지움 (지웠으면 $true)
function Remove-RegKeyIfEmpty([string]$root, [string]$key) {
    $base, $pre = Get-RegBase $root
    $k = $base.OpenSubKey($pre + $key, $false)
    if (-not $k) { return $false }
    try { $empty = ($k.ValueCount -eq 0 -and $k.SubKeyCount -eq 0) } finally { $k.Close() }
    if (-not $empty) { return $false }
    $base.DeleteSubKey($pre + $key, $false)
    return $true
}
function Test-HiveLoaded([string]$name) {
    $k = [Microsoft.Win32.Registry]::Users.OpenSubKey($name, $false)
    if ($k) { $k.Close(); return $true }
    return $false
}
# reg.exe: 내보내기·하이브 불러오기/내리기
function Invoke-Reg([string[]]$argList) { Invoke-Native 'reg.exe' $argList }
# 가져오기는 이름을 바꾼 reg.exe 복사본으로.
# UCPD(사용자 선택 보호 드라이버)가 reg.exe·powershell.exe 같은 정해진 이름이 위젯 관련 키를 쓰는 걸 막아서
# (빌드와 같은 방법. PC 설정·드라이버는 건드리지 않음)
# 참고(유지보수): 혹시 나중에 Windows 업데이트로 UCPD 가 이름 바꾼 복사본까지 막으면,
# 위젯 관련 키(TaskbarDa/Dsh)는 SYSTEM 권한 예약 작업 1회성 실행이나 UCPD 서비스 일시 조정으로 우회해야 할 수 있음.
function Invoke-RegTool([string[]]$argList) { Invoke-Native (Get-RegTool) $argList }
function Get-RegTool {
    $dir  = Join-Path $Here 'regtool'
    $tool = Join-Path $dir 'BeSffyReg.exe'
    if (Test-Path -LiteralPath $tool) { return $tool }
    if (Test-Path -LiteralPath (Join-Path $dir 'LiteReg.exe')) { return (Join-Path $dir 'LiteReg.exe') }   # 예전 이름이 있으면 그대로 씀
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    Copy-Item -LiteralPath (Join-Path $env:SystemRoot 'System32\reg.exe') -Destination $tool -Force
    Get-ChildItem -Path (Join-Path $env:SystemRoot 'System32\*\reg.exe.mui') -ErrorAction SilentlyContinue | ForEach-Object {
        $lang = Join-Path $dir $_.Directory.Name
        New-Item -ItemType Directory -Force -Path $lang | Out-Null
        Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $lang 'BeSffyReg.exe.mui') -Force
    }
    return $tool
}

# ---- 바로가기 ----
function Get-WShell { if (-not $script:WShell) { $script:WShell = New-Object -ComObject WScript.Shell }; $script:WShell }
function Get-LnkTarget([string]$path) { try { "$((Get-WShell).CreateShortcut($path).TargetPath)" } catch { '' } }
function New-RunAsShortcut([string]$path, [string]$target, [string]$arguments, [string]$icon) {
    $l = (Get-WShell).CreateShortcut($path)
    $l.TargetPath = $target; $l.Arguments = $arguments
    if ($icon) { $l.IconLocation = $icon }
    $l.Save()
    Set-LnkRunAs $path
}
# .lnk 의 21번째 바이트 0x20 = '관리자 권한으로 실행'
function Test-LnkRunAs([string]$path) {
    $b = [IO.File]::ReadAllBytes((Get-FsPath $path))
    return ($b.Length -gt 0x15 -and ($b[0x15] -band 0x20) -ne 0)
}
function Set-LnkRunAs([string]$path) {
    $p = Get-FsPath $path
    $b = [IO.File]::ReadAllBytes($p)
    if ($b.Length -le 0x15 -or $b[0] -ne 0x4C) { throw '바로가기 파일 형식이 아니에요' }
    $b[0x15] = $b[0x15] -bor 0x20
    [IO.File]::WriteAllBytes($p, $b)
}
function Clear-LnkRunAs([string]$path) {
    $p = Get-FsPath $path
    $b = [IO.File]::ReadAllBytes($p)
    if ($b.Length -le 0x15 -or $b[0] -ne 0x4C) { throw '바로가기 파일 형식이 아니에요' }
    $b[0x15] = $b[0x15] -band 0xDF
    [IO.File]::WriteAllBytes($p, $b)
}

# ---- 그 밖의 시스템 동작 ----
# 지울 앱이 실행 중이면 먼저 내림 (실행 중이면 Appx 제거가 0x80073CFA '앱이 실행 중' 으로 실패할 수 있음)
# 1) 앱 설치 폴더 안에서 도는 프로세스(확실히 그 앱) + 2) 알려진 백그라운드 프로세스 이름(선택된 앱 것만)
function Stop-AppProcesses([string[]]$names) {
    $map = @{ 'MicrosoftWindows.Client.WebExperience' = @('Widgets', 'WidgetService')
              'MSTeams' = @('ms-teams', 'msteams'); 'Microsoft.OutlookForWindows' = @('olk')
              'Microsoft.XboxGamingOverlay' = @('GameBar', 'GameBarFTServer'); 'Clipchamp.Clipchamp' = @('Clipchamp')
              'Microsoft.549981C3F5F10' = @('Cortana') }
    $locs = @(); $pn = @()
    foreach ($n in $names) {
        foreach ($p in @(Get-AppxPackage -AllUsers -Name $n -ErrorAction SilentlyContinue)) {
            $loc = [Environment]::ExpandEnvironmentVariables("$($p.InstallLocation)"); if ($loc) { $locs += $loc }
        }
        if ($map.ContainsKey($n)) { $pn += $map[$n] }
    }
    foreach ($proc in @(Get-Process -ErrorAction SilentlyContinue)) {
        $hit = ($pn -contains $proc.Name)
        if (-not $hit -and $locs.Count) { $path = $null; try { $path = $proc.Path } catch {}; if ($path) { foreach ($l in $locs) { if ($l -and $path -like "$l\*") { $hit = $true; break } } } }
        if ($hit) { try { Stop-Process -Id $proc.Id -Force -ErrorAction Stop; Say "  실행 중이던 $($proc.Name) 먼저 내림" } catch {} }
    }
}
function Invoke-WuPause { & (Join-Path $script:ToolsDst 'WU-Pause.ps1') -Force }
# Defender 예약 검사 설정 (Set-MpPreference: 그룹 정책이 없는 PC 에서 쓰는 Windows 의 기본 방법). 못 읽으면 $null, 이유는 $script:DefenderErr
function Get-DefenderScanPref {
    $script:DefenderErr = $null
    try { $m = Get-MpPreference -ErrorAction Stop } catch { $script:DefenderErr = "$($_.Exception.Message)".Trim(); return $null }
    if ($null -eq $m.ScanAvgCPULoadFactor) { $script:DefenderErr = '이 Windows 의 Defender 는 이 설정을 지원하지 않음'; return $null }
    $o = [ordered]@{}; foreach ($k in $DefenderWant.Keys) { $o[$k] = $m.$k }
    return $o
}
function Set-DefenderScanPref($v) {
    Set-MpPreference -ScanAvgCPULoadFactor ([byte]$v.ScanAvgCPULoadFactor) -DisableCpuThrottleOnIdleScans ([bool]$v.DisableCpuThrottleOnIdleScans) -EnableLowCpuPriority ([bool]$v.EnableLowCpuPriority) -ErrorAction Stop
}
function Start-Uninstaller([string]$exe, [string]$arguments) { (Start-Process -FilePath $exe -ArgumentList $arguments -Wait -PassThru -ErrorAction Stop).ExitCode }
# 서비스 관리자에도 바로 반영 (레지스트리만 바꾸면 다시 시작할 때까지 예전 값으로 동작함)
function Set-ServiceStartType([string]$name, [string]$scType) { Invoke-Native 'sc.exe' @('config', $name, 'start=', $scType) }
function Test-OneDriveRunning { [bool](Get-Process -Name OneDrive -ErrorAction SilentlyContinue) }
function Stop-OneDrive { Get-Process -Name OneDrive -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue }
# 클라우드에만 있는 파일 수 (OneDrive 를 지우면 이 파일들은 PC 에서 열 수 없게 됨. 클라우드에는 남음)
function Get-CloudOnlyCount([string]$folder) {
    $n = 0; $scanned = 0; $partial = $false
    $sw = [Diagnostics.Stopwatch]::StartNew()
    # 파이프라인으로 하나씩 받아야 60초 제한이 바로 먹힘 (foreach (... in (Get-ChildItem)) 는 목록을 다 만든 뒤에 시작)
    do {
        Get-ChildItem -LiteralPath $folder -Recurse -Force -File -ErrorAction SilentlyContinue | ForEach-Object {
            $scanned++
            if (([int]$_.Attributes -band 0x400000) -or ([int]$_.Attributes -band 0x1000)) { $n++ }
            if ($sw.Elapsed.TotalSeconds -gt 60) { $partial = $true; break }   # break: 바깥 do 를 빠져나감
        }
    } while ($false)
    [pscustomobject]@{ Count = $n; Scanned = $scanned; Partial = $partial }
}
# PowerShell 7: Program Files 설치본 또는 스토어 설치본(Microsoft.PowerShell)
function Test-Pwsh {
    (Test-Path -LiteralPath (Join-Path $env:ProgramFiles 'PowerShell\7\pwsh.exe')) -or
    [bool](Get-AppxPackage -Name Microsoft.PowerShell -ErrorAction SilentlyContinue) -or
    [bool](Get-Command pwsh.exe -ErrorAction SilentlyContinue)
}

# WinForms 를 고해상도(4K/QHD)에서도 선명하게. 창을 만들기 전에 한 번만 DPI 인식 켬
$script:DpiDone = $false
function Enable-DpiAwareness {
    if ($script:DpiDone) { return }
    $script:DpiDone = $true
    try { Add-Type -Namespace BeSffyDpi -Name Win -MemberDefinition '[DllImport("user32.dll")] public static extern bool SetProcessDPIAware();' -ErrorAction Stop; [void][BeSffyDpi.Win]::SetProcessDPIAware() } catch {}
}
function ScalePx([double]$v, [double]$s) { [int][Math]::Round($v * $s) }
# 고르는 창 공통 틀: 위 설명 / 가운데 목록(창 크기에 맞춰 늘고 줄어듦) / 아래 버튼 줄(항상 보임)
# 좌표를 직접 찍지 않고 칸 나누기(TableLayoutPanel)로 배치해서, 창이 작아져도 버튼은 맨 아래에 붙어 있고 목록만 줄어듦.
# 창 크기는 화면 작업 영역(작업 표시줄 뺀 곳) 안으로 맞춤 → 작은 화면·높은 배율에서도 늘리지 않아도 버튼이 보임.
# 돌려줌: @{ Form; List; Left(왼쪽 버튼 줄); Right(오른쪽 버튼 줄); Scale; W; H }
# -Tree: 목록 대신 묶음 트리(프로그램 > 하위 항목, 체크 상자). -Notice: 맨 위 노란 안내 글
# -Radio: 목록 대신 큰 선택지 여러 개 중 하나 (라디오 버튼). 돌려주는 값의 Radios 로 접근
function New-PickerForm([string]$title, [string]$text, [int]$w, [int]$h, [switch]$Tree, [string]$Notice, [string[]]$Radio) {
    Add-Type -AssemblyName System.Windows.Forms, System.Drawing
    [System.Windows.Forms.Application]::EnableVisualStyles()
    Enable-DpiAwareness
    $f = New-Object System.Windows.Forms.Form
    $f.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::None   # 배율은 아래 $sc 로 직접 (글자는 pt 라 알아서 커짐)
    $f.Font = New-Object System.Drawing.Font('Malgun Gothic', 9.5)
    $f.Text = $title; $f.StartPosition = 'CenterScreen'; $f.TopMost = $true; $f.MinimizeBox = $false; $f.ShowIcon = $false
    $sc = 1.0; try { $g = $f.CreateGraphics(); $sc = [Math]::Max(1.0, $g.DpiX / 96.0); $g.Dispose() } catch {}

    $tl = New-Object System.Windows.Forms.TableLayoutPanel
    $tl.Dock = 'Fill'; $tl.ColumnCount = 1; $tl.RowCount = $(if ($Notice) { 4 } else { 3 })
    $tl.Padding = New-Object System.Windows.Forms.Padding((ScalePx 10 $sc))
    [void]$tl.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    if ($Notice) { [void]$tl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize))) }
    [void]$tl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))
    [void]$tl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    [void]$tl.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))

    $labels = @()
    if ($Notice) {
        # 노란 안내 상자 (창 폭 가득, 굵게)
        $nb = New-Object System.Windows.Forms.Label
        $nb.Text = $Notice; $nb.AutoSize = $true; $nb.Dock = 'Fill'
        $nb.BackColor = [System.Drawing.Color]::FromArgb(255, 236, 153); $nb.ForeColor = [System.Drawing.Color]::FromArgb(92, 64, 0)
        $nb.BorderStyle = 'FixedSingle'
        $nb.Font = New-Object System.Drawing.Font('Malgun Gothic', 9.5, [System.Drawing.FontStyle]::Bold)
        $nb.Padding = New-Object System.Windows.Forms.Padding((ScalePx 8 $sc), (ScalePx 6 $sc), (ScalePx 8 $sc), (ScalePx 6 $sc))
        $nb.Margin = New-Object System.Windows.Forms.Padding(0, 0, 0, (ScalePx 8 $sc))
        $labels += $nb
    }
    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = $text; $lbl.AutoSize = $true
    $lbl.Margin = New-Object System.Windows.Forms.Padding(0, 0, 0, (ScalePx 6 $sc))
    $labels += $lbl
    $radios = @()
    if ($Radio) {
        $list = New-Object System.Windows.Forms.FlowLayoutPanel
        $list.FlowDirection = 'TopDown'; $list.WrapContents = $false; $list.AutoScroll = $true
        foreach ($t in $Radio) {
            $rb = New-Object System.Windows.Forms.RadioButton
            $rb.Text = $t; $rb.AutoSize = $true; $rb.CheckAlign = 'TopLeft'; $rb.TextAlign = 'TopLeft'   # 동그라미를 첫 줄에 맞춤
            $rb.Font = New-Object System.Drawing.Font('Malgun Gothic', 10.5)
            $rb.Margin = New-Object System.Windows.Forms.Padding((ScalePx 4 $sc), (ScalePx 6 $sc), 0, (ScalePx 10 $sc))
            $list.Controls.Add($rb); $radios += $rb
        }
    } elseif ($Tree) {
        # 체크 상자를 빠르게 두 번 누르면 화면과 실제 체크가 어긋나는 WinForms 문제를 막은 트리 (만들기 실패하면 보통 트리)
        if (-not ('BeSffyTree' -as [type])) {
            try {
                # WarningAction: public 멤버가 없는 형식이라 Add-Type 이 띄우는 '생성된 유형이 public 메서드…' 경고 숨김 (정상)
                Add-Type -ReferencedAssemblies System.Windows.Forms, System.Drawing -ErrorAction Stop -WarningAction SilentlyContinue -TypeDefinition @'
public class BeSffyTree : System.Windows.Forms.TreeView {
    protected override void WndProc(ref System.Windows.Forms.Message m) {
        if (m.Msg == 0x203) {
            long lp = m.LParam.ToInt64();
            int x = (short)(lp & 0xFFFF), y = (short)((lp >> 16) & 0xFFFF);
            System.Windows.Forms.TreeViewHitTestInfo h = HitTest(x, y);
            if (h != null && h.Location == System.Windows.Forms.TreeViewHitTestLocations.StateImage) { m.Result = System.IntPtr.Zero; return; }
        }
        base.WndProc(ref m);
    }
}
'@
            } catch {}
        }
        $list = if ('BeSffyTree' -as [type]) { New-Object BeSffyTree } else { New-Object System.Windows.Forms.TreeView }
        $list.CheckBoxes = $true; $list.ShowNodeToolTips = $true; $list.HideSelection = $false
        $list.ItemHeight = [Math]::Max($list.ItemHeight, (ScalePx 22 $sc))
    } else {
        $list = New-Object System.Windows.Forms.CheckedListBox
        $list.CheckOnClick = $true; $list.IntegralHeight = $false; $list.HorizontalScrollbar = $true
    }
    $list.Dock = 'Fill'
    $list.Margin = New-Object System.Windows.Forms.Padding(0)

    $bar = New-Object System.Windows.Forms.TableLayoutPanel
    $bar.Dock = 'Fill'; $bar.AutoSize = $true; $bar.AutoSizeMode = 'GrowAndShrink'; $bar.ColumnCount = 2; $bar.RowCount = 1
    $bar.Margin = New-Object System.Windows.Forms.Padding(0, (ScalePx 8 $sc), 0, 0)
    [void]$bar.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::Percent, 100)))
    [void]$bar.ColumnStyles.Add((New-Object System.Windows.Forms.ColumnStyle([System.Windows.Forms.SizeType]::AutoSize)))
    [void]$bar.RowStyles.Add((New-Object System.Windows.Forms.RowStyle([System.Windows.Forms.SizeType]::AutoSize)))
    $left = New-Object System.Windows.Forms.FlowLayoutPanel; $right = New-Object System.Windows.Forms.FlowLayoutPanel
    foreach ($fp in $left, $right) { $fp.AutoSize = $true; $fp.AutoSizeMode = 'GrowAndShrink'; $fp.WrapContents = $false; $fp.Margin = New-Object System.Windows.Forms.Padding(0) }
    $left.Anchor = 'Left'; $right.Anchor = 'Right'
    $bar.Controls.Add($left, 0, 0); $bar.Controls.Add($right, 1, 0)

    $row = 0
    foreach ($l in $labels) { $tl.Controls.Add($l, 0, $row); $row++ }
    $tl.Controls.Add($list, 0, $row); $tl.Controls.Add($bar, 0, ($row + 1))
    $f.Controls.Add($tl)
    # 설명 글은 창 폭에 맞춰 줄바꿈 (창을 줄여도 잘리지 않게)
    $f.Tag = @{ Labels = $labels; Panel = $tl }
    $wrap = { $t = $this.Tag; if ($t) { $lw = $t.Panel.ClientSize.Width - $t.Panel.Padding.Horizontal - 2; if ($lw -gt 50) { foreach ($l in $t.Labels) { $l.MaximumSize = New-Object System.Drawing.Size($lw, 0) } } } }
    $f.Add_Load($wrap); $f.Add_Resize($wrap)
    return @{ Form = $f; List = $list; Left = $left; Right = $right; Scale = $sc; W = $w; H = $h; Radios = $radios }
}
function Add-PickerButton($p, [string]$side, [string]$text, [string]$result) {
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $text; $b.AutoSize = $true
    $b.MinimumSize = New-Object System.Drawing.Size((ScalePx 88 $p.Scale), (ScalePx 30 $p.Scale))
    $b.Margin = New-Object System.Windows.Forms.Padding(0, 0, (ScalePx 6 $p.Scale), 0)
    if ($result) { $b.DialogResult = $result; if ($result -eq 'OK') { $p.Form.AcceptButton = $b } else { $p.Form.CancelButton = $b } }
    $p[$side].Controls.Add($b)
    return $b
}
# 창 크기를 화면 작업 영역 안으로 맞춰서 띄움 (마우스가 있는 화면 기준)
function Show-PickerForm($p) {
    $f = $p.Form; $sc = $p.Scale
    $wa = [System.Windows.Forms.Screen]::FromPoint([System.Windows.Forms.Cursor]::Position).WorkingArea
    # 화면의 90% 를 넘지 않게 (1080p 150% 처럼 세로가 빠듯한 화면에서도 위아래 여유)
    $W = [Math]::Min((ScalePx $p.W $sc), [int]($wa.Width * 0.9))
    $H = [Math]::Min((ScalePx $p.H $sc), [int]($wa.Height * 0.9))
    $f.Size = New-Object System.Drawing.Size($W, $H)
    $f.MinimumSize = New-Object System.Drawing.Size([Math]::Min($W, (ScalePx 560 $sc)), [Math]::Min($H, (ScalePx 260 $sc)))
    return $f.ShowDialog()
}
function Set-AllChecked($list, [bool]$v) { for ($i = 0; $i -lt $list.Items.Count; $i++) { $list.SetItemChecked($i, $v) } }

# 지울 앱 고르는 창. 확인 → 고른 이름 목록(빈 목록일 수 있음), 취소·닫기 → $null
function Show-AppPicker($apps, [string[]]$preselected) {
    $p = New-PickerForm '지울 앱 고르기 - BeSffy' ("지울 앱만 체크하세요. 쓰고 있는 앱은 체크하지 마세요.`n" +
        "(이 PC 의 모든 사용자에게서 지워지고, 새 사용자에게도 설치되지 않아요. 취소하면 이번 작업을 멈추고 아무것도 저장하지 않아요)") 640 660
    $f = $p.Form; $list = $p.List
    foreach ($a in $apps) {
        $i = $list.Items.Add(("{0}   [{1}]   {2} · {3}" -f $a.Label, $a.Group, (Get-AppStateText $a), $a.Name))
        if ($preselected -contains $a.Name) { $list.SetItemChecked($i, $true) }
    }
    (Add-PickerButton $p 'Left' '모두 선택').Add_Click({ Set-AllChecked $list $true })
    (Add-PickerButton $p 'Left' '모두 해제').Add_Click({ Set-AllChecked $list $false })
    (Add-PickerButton $p 'Left' '기본값').Add_Click({ for ($i = 0; $i -lt $list.Items.Count; $i++) { $list.SetItemChecked($i, ($preselected -contains $apps[$i].Name)) } })
    [void](Add-PickerButton $p 'Right' '확인' 'OK')
    [void](Add-PickerButton $p 'Right' '취소' 'Cancel')
    $res = Show-PickerForm $p
    $picked = @()
    foreach ($i in $list.CheckedIndices) { $picked += $apps[$i].Name }
    $f.Dispose()
    if ("$res" -ne 'OK') { return $null }
    return ,$picked
}

# ============================== 경로·이 PC 정보 ==============================
function Initialize-Paths {
    $script:ReportDir  = Join-Path $Here 'reports'
    $script:BackupRoot = Join-Path $Here 'backup'
    $script:SelFile    = Join-Path $Here 'selected_apps.txt'
    $script:ToolsDst   = Join-Path $env:ProgramData $ToolsDirName
    $script:ToolsDstOld = Join-Path $env:ProgramData 'LiteTools'   # 예전 이름 (되돌리기 때 같이 정리)
    $pub = if ($env:PUBLIC) { $env:PUBLIC } else { Join-Path $env:SystemDrive 'Users\Public' }
    $script:PublicDesk = Join-Path $pub 'Desktop'
    $script:PowerShellExe = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
    $script:TerminalFile  = Join-Path $env:LOCALAPPDATA "Packages\$TerminalPkg\LocalState\settings.json"
    $script:StartMenuDirs = @((Join-Path $env:ProgramData 'Microsoft\Windows\Start Menu\Programs'),
                              (Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'))
    # 새 사용자 기본 프로필 폴더 (보통 C:\Users\Default)
    $pl = Get-RegValue $HKLM 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList' 'Default'
    $defDir = if ($pl.Exists -and "$($pl.Value)") { [Environment]::ExpandEnvironmentVariables("$($pl.Value)") } else { Join-Path $env:SystemDrive 'Users\Default' }
    $script:DefaultNtUser = Join-Path $defDir 'NTUSER.DAT'
    $script:OptFile = Join-Path $Here 'selected_options.txt'    # 무엇을 적용할지 (창에서 고른 값)
    $script:BgFile  = Join-Path $Here 'selected_bgapps.txt'     # 백그라운드 예외로 둘 앱 (창에서 고른 값)
    $script:StartupFile = Join-Path $Here 'selected_startup.txt' # 시작 프로그램에서 끄고 켤 것 (창에서 고른 값)
}

function Initialize-Context {
    $nt = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    $w = @{}
    foreach ($n in 'ProductName', 'DisplayVersion', 'CurrentBuild', 'UBR', 'EditionID') {
        $v = Get-RegValue $HKLM $nt $n; $w[$n] = if ($v.Exists) { "$($v.Value)".Trim() } else { '' }
    }
    $build = 0; [void][int]::TryParse($w.CurrentBuild, [ref]$build)
    # Windows 11 도 레지스트리 ProductName 은 'Windows 10 ...' 으로 남아 있음
    if ($build -ge 22000) { $w.ProductName = $w.ProductName -replace '^Windows 10', 'Windows 11' }
    $script:Win = [pscustomobject]@{ ProductName = $w.ProductName; DisplayVersion = $w.DisplayVersion; Build = $w.CurrentBuild; UBR = $w.UBR; Edition = $w.EditionID }
    $script:DisplayVersion = $w.DisplayVersion
    $script:ProductVersion = if ($build -gt 0 -and $build -lt 22000) { 'Windows 10' } else { 'Windows 11' }

    # 백그라운드 예외 목록: 저장해 둔 것(창에서 고른 값)이 있으면 그걸, 없으면 패턴에 맞는 앱을 기본값으로
    $script:BgEmptyLegacy = $false
    $sp = Read-StartupSelection
    $script:StartupPlan = if ($null -eq $sp) { @() } else { @($sp) }   # Build-RegItems 가 씀 (아래 Set-BgExtra 안에서)
    $saved = Read-BgSelection
    if ($null -ne $saved) { Set-BgExtra $saved } else { Set-BgExtra (Get-BgDefaultFamilies) }
}
# 백그라운드 예외(패키지 패밀리 이름)를 정하고 레지스트리 항목을 다시 만듦
function Set-BgExtra([string[]]$families) {
    $script:BgExtra = @($families | Where-Object { $_ } | Sort-Object -Unique)
    Build-RegItems
    $script:BgAllowed = @($script:Reg | Where-Object Name -eq 'LetAppsRunInBackground_ForceAllowTheseApps' | ForEach-Object { $_.Value })
}
# 추천(클라우드·휴대폰 연동·메신저·제조사 도우미 등)에 맞는, 이 PC 에 설치된 앱의 패키지 패밀리 이름 (창의 기본 체크용)
function Get-BgDefaultFamilies {
    @(Get-BgCandidates | Where-Object Rec | ForEach-Object { $_.Family } | Sort-Object -Unique)
}
# 추천 종류 (없으면 빈 글자)
function Get-BgKind([string]$name) {
    foreach ($k in $BgRecommend.Keys) { foreach ($pt in $BgRecommend[$k]) { if ($name -like $pt) { return $k } } }
    return ''
}
# 시작 메뉴에 보이는 앱 이름 (패밀리 이름 → 이름). 한 작업 안에서 한 번만 읽음
function Get-StartAppNames {
    if ($null -ne $script:_startNames) { return $script:_startNames }
    $h = @{}
    try {
        foreach ($sa in @(Get-StartApps -ErrorAction Stop)) {
            if ("$($sa.AppID)" -match '^([^!\\]+_[a-z0-9]{13})!') { if (-not $h.ContainsKey($Matches[1])) { $h[$Matches[1]] = "$($sa.Name)" } }
        }
    } catch {}
    $script:_startNames = $h
    return $h
}
# 알기 쉬운 이름: 직접 붙인 이름 → 앱 목록 이름 → 시작 메뉴 이름 → 패키지 이름을 풀어 씀 (SamsungCloudSync → Samsung Cloud Sync)
function Get-BgLabel([string]$name, [string]$family) {
    foreach ($l in $BgLabels) { if ($name -like $l[0]) { return $l[1] } }
    $c = Get-AppLabel $name; if ($c -ne $name) { return $c }
    $sn = (Get-StartAppNames)[$family]; if ($sn -and $sn -notmatch '^ms-resource:') { return $sn }
    $t = if ($name -match '^[^.]+\.(.+)$') { $Matches[1] } else { $name }
    return (($t -creplace '([a-z])([A-Z])', '$1 $2') -replace '\.', ' ').Trim()
}
# 묶을 프로그램 이름: 아는 회사·프로그램 → 패키지 게시자(O=) → 앱 이름
function Get-BgGroup([string]$name, [string]$publisher, [string]$label) {
    foreach ($v in $BgVendors) { if ($name -like $v[0]) { return $v[1] } }
    if ("$publisher" -match '(?:^|,\s*)O=("[^"]+"|[^,]+)') { $o = $Matches[1].Trim('"', ' '); if ($o -and $o -notmatch '^[0-9A-Fa-f-]{20,}$') { return $o } }
    if ("$publisher" -match '^CN=("[^"]+"|[^,]+)') { $o = $Matches[1].Trim('"', ' '); if ($o -and $o -notmatch '^[0-9A-Fa-f-]{20,}$') { return $o } }
    return $label
}

# ============================== 레지스트리 항목 ==============================
# Hive: HKLM / HKCU (HKCU 는 지금 사용자 + 새 사용자 기본값에 같이 적용, CurOnly 면 지금 사용자만)
# Kind: DWord / String / MultiString / DeleteValue / DeleteKey / EnsureKey / Track(값을 바꾸지 않고 되돌리기용으로만 기록)
# Skip: 이 PC 에서 건너뛰는 이유 (있으면 적용·점검하지 않음)
function Add-RegItem([string]$cat, [string]$hive, [string]$key, [string]$name, [string]$kind, $value, [string]$desc, [switch]$CurOnly) {
    # 0x10000000 처럼 16진수로 쓴 숫자는 원래 글자('0x...')가 따라다녀서 비교가 틀어짐 → 순수한 숫자로
    if ($kind -eq 'DWord') { $value = [int64]$value }
    if ($kind -eq 'MultiString') { $value = [string[]]@($value) }
    $script:Reg.Add([pscustomobject]@{ Cat = $cat; Hive = $hive; Key = $key; Name = $name; Kind = $kind; Value = $value; Desc = $desc; CurOnly = [bool]$CurOnly; Skip = $null })
}
function Build-RegItems {
    $script:Reg = New-Object System.Collections.Generic.List[object]
    $cv  = 'SOFTWARE\Microsoft\Windows\CurrentVersion'
    $pol = 'SOFTWARE\Policies\Microsoft'
    $adv = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    $cdm = 'Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'

    # ---- 설정·정책: 시스템 (HKLM) ----
    Add-RegItem Settings HKLM "$cv\WindowsUpdate\Orchestrator\UScheduler\OutlookUpdate" workCompleted DWord 1 '새 Outlook 자동 설치 막기'
    Add-RegItem Settings HKLM "$cv\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate" workCompleted DWord 1 '새 Outlook 자동 설치 막기 (설치 직후용)'
    Add-RegItem Settings HKLM 'SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate' '' DeleteKey $null '새 Outlook 설치 예약 지우기'
    Add-RegItem Settings HKLM "$cv\WindowsUpdate\Orchestrator\UScheduler\DevHomeUpdate" workCompleted DWord 1 'Dev Home 자동 설치 막기'
    Add-RegItem Settings HKLM 'SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate' '' DeleteKey $null 'Dev Home 설치 예약 지우기'
    # 누적 업데이트 뒤 몰래 다시 까는 것 보강 차단 (OOBE 업데이터 차단 목록 + 새 Outlook 강제 전환 끄기)
    Add-RegItem Settings HKLM 'SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe' BlockedOobeUpdaters String '["MS_Outlook","MS_Teams","MS_DevHome"]' 'OOBE 업데이터 차단 목록 (Outlook·Teams·Dev Home)'
    Add-RegItem Settings HKCU 'Software\Policies\Microsoft\office\16.0\outlook\preferences' NewOutlookMigrationUserSetting DWord 0 '새 Outlook 강제 전환 막기'
    Add-RegItem Settings HKLM "$pol\Windows\Windows Mail" PreventRun DWord 1 '옛 메일 앱 실행 막기'
    Add-RegItem Settings HKLM "$pol\Teams" DisableInstallation DWord 1 'Teams 자동 설치 막기'
    Add-RegItem Settings HKLM "$pol\Windows\CloudContent" DisableWindowsConsumerFeatures DWord 1 '추천 앱 자동 설치 끄기'
    Add-RegItem Settings HKLM "$pol\Windows\CloudContent" DisableConsumerAccountStateContent DWord 1 '계정 관련 홍보 끄기'
    Add-RegItem Settings HKLM "$pol\Windows\CloudContent" DisableCloudOptimizedContent DWord 1 '클라우드 추천 콘텐츠 끄기'
    Add-RegItem Settings HKLM "$pol\PushToInstall" DisablePushToInstall DWord 1 '웹에서 원격으로 앱 설치 끄기'
    Add-RegItem Settings HKLM "$pol\Windows\Windows Chat" ChatIcon DWord 3 '채팅 아이콘 숨기기'
    Add-RegItem Settings HKLM "$cv\Explorer\Advanced" TaskbarMn DWord 0 '작업 표시줄 채팅 숨기기 (시스템)'
    Add-RegItem Settings HKLM "$pol\Windows\DataCollection" AllowTelemetry DWord 0 '진단 데이터 최소 (Pro 는 필수 수준)'
    Add-RegItem Settings HKLM "$pol\Windows\Personalization" NoLockScreen DWord 1 '잠금 화면 없이 바로 로그인 화면'
    Add-RegItem Settings HKLM 'SOFTWARE\Microsoft\Windows\Dwm' OverlayMinFPS DWord 0 'Alt+Tab 화면 깜빡임 해결'
    Add-RegItem Settings HKLM 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\PasswordLess\Device' DevicePasswordLessBuildVersion DWord 0 '비밀번호 로그인도 허용'
    Add-RegItem Settings HKLM "$pol\Edge" StartupBoostEnabled DWord 0 'Edge 시작 부스트 끄기'
    Add-RegItem Settings HKLM "$pol\Edge" BackgroundModeEnabled DWord 0 'Edge 백그라운드 실행 끄기'
    Add-RegItem Settings HKLM "$pol\Windows\AppPrivacy" LetAppsRunInBackground DWord 2 '스토어 앱 백그라운드 실행 금지'
    $bg = @($BgAlways) + @($script:BgExtra | Where-Object { $_ })
    Add-RegItem Settings HKLM "$pol\Windows\AppPrivacy" LetAppsRunInBackground_ForceAllowTheseApps MultiString $bg `
        "예외: 휴대폰과 연결$(if (@($script:BgExtra).Count) { " + 고른 앱 $(@($script:BgExtra).Count)개" })"
    Add-RegItem Settings HKLM "$pol\Windows\WindowsAI" AllowRecallEnablement DWord 0 'Recall 끄기'
    Add-RegItem Settings HKLM "$pol\Windows\WindowsAI" DisableAIDataAnalysis DWord 1 'AI 화면 분석 끄기'
    Add-RegItem Settings HKLM "$pol\Windows\WindowsAI" TurnOffSavingSnapshots DWord 1 'Recall 스냅샷 저장 끄기'
    Add-RegItem Settings HKLM "$pol\Windows\WindowsAI" DisableClickToDo DWord 1 'Click to Do 끄기'
    Add-RegItem Settings HKLM "$pol\Dsh" AllowNewsAndInterests DWord 0 '위젯 끄기'
    Add-RegItem Settings HKLM "$cv\Policies\NonEnum" '{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}' DWord 1 '탐색기 갤러리 숨기기 (시스템)'
    Add-RegItem Settings HKLM 'SYSTEM\CurrentControlSet\Control\BitLocker' PreventDeviceEncryption DWord 1 'BitLocker 자동 암호화 막기 (이미 암호화된 드라이브는 그대로)'
    Add-RegItem Settings HKLM 'SYSTEM\CurrentControlSet\Control\FileSystem' LongPathsEnabled DWord 1 '260자 넘는 긴 경로 허용'
    Add-RegItem Settings HKLM 'SYSTEM\CurrentControlSet\Control\Session Manager\Power' HiberbootEnabled DWord 0 '빠른 시작 끄기'
    Add-RegItem Settings HKLM 'SYSTEM\CurrentControlSet\Control' SvcHostSplitThresholdInKB DWord 0x10000000 '서비스 프로세스 묶기 (메모리 절약, 다시 시작 후)'
    Add-RegItem Settings HKLM 'SYSTEM\Setup\MoSetup' AllowUpgradesWithUnsupportedTPMOrCPU DWord 1 '나중에 버전 업그레이드 때 TPM/CPU 검사 우회'
    Add-RegItem Settings HKLM 'SYSTEM\CurrentControlSet\Services\DiagTrack' Start DWord 4 '원격 분석 서비스(DiagTrack) 사용 안 함'
    Add-RegItem Settings HKLM 'SYSTEM\CurrentControlSet\Services\WSAIFabricSvc' Start DWord 3 'Windows AI 서비스 수동 (필요할 때만)'

    # ---- 설정·정책: 사용자 (HKCU + 새 사용자 기본값) ----
    Add-RegItem Settings HKCU $adv LaunchTo DWord 1 '탐색기 시작 = 내 PC'
    Add-RegItem Settings HKCU $adv TaskbarMn DWord 0 '작업 표시줄 채팅 숨기기'
    Add-RegItem Settings HKCU $adv TaskbarDa DWord 0 '작업 표시줄 위젯 숨기기'
    Add-RegItem Settings HKCU $adv ShowTaskViewButton DWord 0 '작업 보기 버튼 숨기기'
    Add-RegItem Settings HKCU $adv ShowSyncProviderNotifications DWord 0 '탐색기 동기화 공급자 알림 끄기'
    Add-RegItem Settings HKCU $adv HideFileExt DWord 0 '파일 확장자 표시'
    Add-RegItem Settings HKCU $adv Hidden DWord 1 '숨긴 파일 표시'
    Add-RegItem Settings HKCU "$adv\TaskbarDeveloperSettings" TaskbarEndTask DWord 1 '작업 표시줄 우클릭에 작업 끝내기'
    Add-RegItem Settings HKCU 'Software\Policies\Microsoft\Windows\WindowsCopilot' TurnOffWindowsCopilot DWord 1 'Copilot 끄기'
    Add-RegItem Settings HKCU 'Software\Policies\Microsoft\Windows\CloudContent' DisableSpotlightCollectionOnDesktop DWord 1 '바탕화면 추천 배경 끄기'
    Add-RegItem Settings HKCU 'Software\Policies\Microsoft\Windows\CloudContent' DisableWindowsConsumerFeatures DWord 1 '추천 앱·팝업 끄기'
    Add-RegItem Settings HKCU 'Software\Microsoft\Windows\CurrentVersion\DesktopSpotlight\Settings' EnabledState DWord 0 '바탕화면 Spotlight 끄기'
    Add-RegItem Settings HKCU 'Software\Policies\Microsoft\Windows\Explorer' DisableSearchBoxSuggestions DWord 1 '검색 웹 결과 끄기'
    Add-RegItem Settings HKCU 'Software\Microsoft\Windows\CurrentVersion\Search' BingSearchEnabled DWord 0 '검색에서 Bing 끄기'
    Add-RegItem Settings HKCU 'Software\Microsoft\Windows\CurrentVersion\GameDVR' AppCaptureEnabled DWord 0 'Xbox 게임 녹화 끄기'
    Add-RegItem Settings HKCU 'System\GameConfigStore' GameDVR_Enabled DWord 0 'Xbox 게임 녹화 끄기 (게임 설정)'
    foreach ($n in 'ContentDeliveryAllowed', 'OemPreInstalledAppsEnabled', 'PreInstalledAppsEnabled', 'PreInstalledAppsEverEnabled',
                   'SilentInstalledAppsEnabled', 'SystemPaneSuggestionsEnabled', 'FeatureManagementEnabled', 'SoftLandingEnabled',
                   'SubscribedContentEnabled', 'SubscribedContent-310093Enabled', 'SubscribedContent-338388Enabled',
                   'SubscribedContent-338389Enabled', 'SubscribedContent-338393Enabled', 'SubscribedContent-353694Enabled',
                   'SubscribedContent-353696Enabled') {
        Add-RegItem Settings HKCU $cdm $n DWord 0 "추천·광고 끄기 ($n)"
    }
    Add-RegItem Settings HKCU "$cdm\Subscriptions" '' DeleteKey $null '추천 구독 목록 지우기'
    Add-RegItem Settings HKCU "$cdm\SuggestedApps" '' DeleteKey $null '추천 앱 목록 지우기'
    Add-RegItem Settings HKCU 'Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement' ScoobeSystemSettingEnabled DWord 0 "'장치 설정을 완료합니다' 팝업 끄기"
    Add-RegItem Settings HKCU 'Software\Microsoft\Windows\CurrentVersion\Privacy' TailoredExperiencesWithDiagnosticDataEnabled DWord 0 '맞춤형 환경 끄기'
    Add-RegItem Settings HKCU 'Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' Enabled DWord 0 '광고 ID 끄기'
    Add-RegItem Settings HKCU 'Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy' HasAccepted DWord 0 '온라인 음성 인식 끄기'
    Add-RegItem Settings HKCU 'Software\Microsoft\Input\TIPC' Enabled DWord 0 '입력 데이터 전송 끄기'
    Add-RegItem Settings HKCU 'Software\Microsoft\InputPersonalization' RestrictImplicitInkCollection DWord 1 '필기 데이터 수집 끄기'
    Add-RegItem Settings HKCU 'Software\Microsoft\InputPersonalization' RestrictImplicitTextCollection DWord 1 '입력 데이터 수집 끄기'
    Add-RegItem Settings HKCU 'Software\Microsoft\InputPersonalization\TrainedDataStore' HarvestContacts DWord 0 '연락처 수집 끄기'
    Add-RegItem Settings HKCU 'Software\Microsoft\Personalization\Settings' AcceptedPrivacyPolicy DWord 0 '개인 설정 데이터 동의 끄기'
    Add-RegItem Settings HKCU 'Control Panel\UnsupportedHardwareNotificationCache' SV1 DWord 0 '권장 사양 미달 알림 끄기 (1)'
    Add-RegItem Settings HKCU 'Control Panel\UnsupportedHardwareNotificationCache' SV2 DWord 0 '권장 사양 미달 알림 끄기 (2)'
    Add-RegItem Settings HKCU 'Control Panel\Desktop' AutoEndTasks String '0' '종료할 때 프로그램 강제 종료 안 함 (저장 안 한 작업 보호)'
    Add-RegItem Settings HKCU 'Control Panel\Desktop' MenuShowDelay String '0' '메뉴 지연 없애기'
    # 탐색기가 실제로 읽는 곳은 Explorer\Serialize (예전 버전·WinLite 원본은 Explorer 에 써서 효과가 없었음)
    Add-RegItem Settings HKCU 'Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize' StartupDelayInMSec DWord 0 '시작 프로그램 지연 없애기'
    Add-RegItem Settings HKCU 'Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize' WaitForIdleState DWord 0 '시작 프로그램 대기 없애기'
    Add-RegItem Settings HKCU 'Software\Microsoft\Windows\CurrentVersion\Explorer' StartupDelayInMSec DeleteValue $null '예전 버전이 효과 없는 곳에 넣은 지연 값 정리'
    Add-RegItem Settings HKCU 'Software\Microsoft\Windows\CurrentVersion\Explorer' WaitForIdleState DeleteValue $null '예전 버전이 효과 없는 곳에 넣은 대기 값 정리'
    Add-RegItem Settings HKCU 'Software\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore' '' EnsureKey $null '프로그램별 볼륨 설정 저장'
    Add-RegItem Settings HKCU 'Software\Policies\Microsoft\Windows\WindowsAI' DisableAIDataAnalysis DWord 1 'AI 화면 분석 끄기 (사용자)'
    Add-RegItem Settings HKCU 'Software\Policies\Microsoft\Windows\WindowsAI' DisableClickToDo DWord 1 'Click to Do 끄기 (사용자)'
    Add-RegItem Settings HKCU 'Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel' '{2cc5ca98-6485-489a-920e-b3e88a6ccce3}' DWord 1 "바탕화면 '이 사진에 대해 알아보기' 숨기기"
    Add-RegItem Settings HKCU 'Control Panel\Accessibility\StickyKeys' Flags String '506' 'Shift 5번 고정 키 팝업 끄기'
    Add-RegItem DarkMode HKCU 'Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' AppsUseLightTheme DWord 0 '다크 모드 (앱)'
    Add-RegItem DarkMode HKCU 'Software\Microsoft\Windows\CurrentVersion\Themes\Personalize' SystemUsesLightTheme DWord 0 '다크 모드 (시스템)'
    Add-RegItem Settings HKCU 'Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32' '' String '' '클래식 우클릭 메뉴 (Windows 10 스타일)' -CurOnly
    Add-RegItem Settings HKCU 'Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}' 'System.IsPinnedToNameSpaceTree' DWord 0 '탐색기 갤러리 숨기기 (사용자)' -CurOnly

    # ---- 검색 색인 ----
    Add-RegItem Search HKLM 'SYSTEM\CurrentControlSet\Services\WSearch' Start DWord 4 '검색 색인(WSearch) 사용 안 함'

    # ---- 업데이트 잠금 ----
    $wu = "$pol\Windows\WindowsUpdate"
    Add-RegItem Update HKLM "$wu\AU" NoAutoUpdate DWord 1 '자동 업데이트 끄기 (직접 확인·설치는 가능)'
    Add-RegItem Update HKLM "$wu\AU" AUOptions DWord 2 '업데이트 방식: 알림만'
    Add-RegItem Update HKLM "$wu\AU" NoAutoRebootWithLoggedOnUsers DWord 1 '로그인 중 자동 재시작 안 함'
    Add-RegItem Update HKLM $wu ExcludeWUDriversInQualityUpdate DWord 1 '드라이버는 Windows Update 로 받지 않음'
    Add-RegItem Update HKLM $wu TargetReleaseVersion DWord 1 '기능 버전 고정 켜기'
    Add-RegItem Update HKLM $wu ProductVersion String $script:ProductVersion '고정할 제품'
    Add-RegItem Update HKLM $wu TargetReleaseVersionInfo String $script:DisplayVersion '고정할 버전 (지금 설치된 버전)'
    Add-RegItem Update HKLM "$pol\Windows\DeliveryOptimization" DODownloadMode DWord 0 '다른 PC 와 업데이트 파일 주고받기 끄기'
    Add-RegItem Update HKLM "$pol\MRT" DontOfferThroughWUAU DWord 1 '악성 소프트웨어 제거 도구를 업데이트로 안 받음'
    foreach ($n in 'PauseUpdatesStartTime', 'PauseFeatureUpdatesStartTime', 'PauseQualityUpdatesStartTime',
                   'PauseUpdatesExpiryTime', 'PauseFeatureUpdatesEndTime', 'PauseQualityUpdatesEndTime', 'FlightSettingsMaxPauseDays') {
        Add-RegItem Update HKLM 'SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' $n Track $null '일시정지 값 (되돌리기용 기록)'
    }
    foreach ($n in 'UpdateMode', 'UpdateModeSince') { Add-RegItem Update HKLM $FlagKey $n Track $null '업데이트 켜기/끄기 상태 (되돌리기용 기록)' }

    # ---- OneDrive ----
    Add-RegItem OneDrive HKLM "$pol\Windows\OneDrive" DisableFileSyncNGSC DWord 1 'OneDrive 동기화 막기 (다시 설치돼도 동작 안 함)'
    Add-RegItem OneDrive HKCU 'Software\Microsoft\Windows\CurrentVersion\Run' OneDrive DeleteValue $null 'OneDrive 자동 실행 지우기'
    Add-RegItem OneDrive HKCU 'Software\Microsoft\Windows\CurrentVersion\Run' OneDriveSetup DeleteValue $null '새 사용자 OneDrive 자동 설치 지우기'

    # 버전 이름(예: 26H2)을 못 읽으면 버전 고정은 통째로 건너뜀 (빈 값으로 고정하면 업데이트 검사가 오류를 냄)
    if (-not $script:DisplayVersion) {
        foreach ($r in $script:Reg) {
            if ($r.Name -in 'TargetReleaseVersion', 'ProductVersion', 'TargetReleaseVersionInfo') { $r.Skip = '지금 버전 이름(DisplayVersion)을 읽지 못함' }
        }
    }

    # ---- 시작 프로그램 (창에서 바꾼 것만): 작업 관리자와 같은 켜짐/꺼짐 기록. 원래 항목은 지우지 않음 ----
    foreach ($c in @($script:StartupPlan)) {
        $t = Get-StartupTarget $c.Id
        if (-not $t) { continue }
        Add-RegItem Startup $t.Hive $t.Key $t.Name $t.Kind $(if ($c.Want) { $t.On } else { $t.Off }) "시작 프로그램 $(if ($c.Want) { '켬' } else { '끔' }): $($c.Label)" -CurOnly
        if (-not $t.Exists) { $script:Reg[$script:Reg.Count - 1].Skip = "시작 프로그램 '$($c.Label)' 이 지금은 없음 (지웠거나 이름이 바뀜)" }
    }
}

$CatLabels = @{ Settings = '설정·정책'; DarkMode = '다크 모드'; Search = '검색 색인'; Update = '업데이트 잠금'; OneDrive = 'OneDrive'; Startup = '시작 프로그램' }
$CatOrder  = [Collections.Generic.List[string]]@('Settings', 'DarkMode', 'Search', 'Update', 'OneDrive', 'Startup')

# 이번에 다룰 항목. $flags: 무엇을 적용(점검)하는지 (Settings/DarkMode/DisableSearch/UpdateLock/OneDrive)
function Get-ActiveRegItems($flags) {
    @($script:Reg | Where-Object {
        -not $_.Skip -and (
            ($_.Cat -eq 'Settings' -and $flags.Settings) -or ($_.Cat -eq 'DarkMode' -and $flags.DarkMode) -or
            ($_.Cat -eq 'Search' -and $flags.DisableSearch) -or ($_.Cat -eq 'Update' -and $flags.UpdateLock) -or
            ($_.Cat -eq 'OneDrive' -and $flags.OneDrive) -or ($_.Cat -eq 'Startup' -and $flags.Startup))
    } | Where-Object {
        # 서비스 설정은 그 서비스가 있을 때만 (없는 서비스 키를 새로 만들면 부팅 때 오류가 남)
        $_.Key -notlike 'SYSTEM\CurrentControlSet\Services\*' -or (Get-RegValue $HKLM $_.Key '').KeyExists
    })
}
function Get-SkippedRegItems($flags) {
    @($script:Reg | Where-Object { $_.Skip -and ($_.Cat -ne 'Update' -or $flags.UpdateLock) -and ($_.Cat -ne 'Startup' -or $flags.Startup) })
}

# ============================== 레지스트리 도구 ==============================
function Get-RootName([string]$hive, [switch]$Default) {
    if ($hive -eq 'HKLM') { 'HKEY_LOCAL_MACHINE' } elseif ($Default) { "HKEY_USERS\$DefHive" } else { 'HKEY_CURRENT_USER' }
}
function Format-RegName([string]$n) { if ($n -eq '') { '@' } else { '"' + ($n -replace '\\', '\\' -replace '"', '\"') + '"' } }
function ConvertTo-RegHex([byte[]]$b) { (@($b) | ForEach-Object { $_.ToString('x2') }) -join ',' }
# .reg 파일 한 줄 (값 쓰기). Kind: DWord/QWord/String/ExpandString/MultiString/Binary/None
function Format-RegLine([string]$name, [string]$kind, $value) {
    $n = Format-RegName $name
    switch ($kind) {
        'DWord'        { return "$n=dword:" + ([uint32]([int64]$value -band 4294967295)).ToString('x8') }
        'QWord'        { return "$n=hex(b):" + (ConvertTo-RegHex ([BitConverter]::GetBytes([int64]$value))) }
        'String'       { return "$n=`"" + ("$value" -replace '\\', '\\' -replace '"', '\"') + '"' }
        'ExpandString' { return "$n=hex(2):" + (ConvertTo-RegHex ([Text.Encoding]::Unicode.GetBytes("$value" + [char]0))) }
        'MultiString'  {
            $s = (@($value) -join [char]0) + [char]0 + [char]0
            return "$n=hex(7):" + (ConvertTo-RegHex ([Text.Encoding]::Unicode.GetBytes($s)))
        }
        'Binary'       { return "$n=hex:" + (ConvertTo-RegHex ([byte[]]$value)) }
        'None'         { return "$n=hex(0):" + (ConvertTo-RegHex ([byte[]]@($value | Where-Object { $null -ne $_ }))) }
        default        { throw "지원하지 않는 값 종류: $kind ($name)" }
    }
}
$KindNames = @{ DWord = 'DWORD'; QWord = 'QWORD'; String = '문자열'; ExpandString = '확장 문자열'; MultiString = '다중 문자열'; Binary = '이진'; None = '형식 없음' }
function Format-Shown($v) {
    if ($null -eq $v) { return '없음' }
    if ($v -is [byte[]]) { return "(이진 $($v.Length)바이트)" }
    if ($v -is [array]) { return (@($v) -join ', ') }
    if ($v -is [int] -or $v -is [uint32]) { return "$([int64]$v -band 4294967295)" }
    if ($v -is [long]) { return "$v" }
    return "`"$v`""
}
# 지금 값 표시 (종류가 다르면 종류도 같이)
function Format-Cur($cur, [string]$wantKind) {
    if ($cur.Error) { return "읽을 수 없음 ($($cur.Error))" }
    if (-not $cur.Exists) { return '없음' }
    $t = Format-Shown $cur.Value
    if ($wantKind -and $cur.Kind -ne $wantKind) { $t += " ($($KindNames[$cur.Kind]))" }
    return $t
}
# 종류까지 맞아야 같은 값 (DWORD 는 부호 없는 32비트로 비교)
function Test-SameValue($cur, $r) {
    if (-not $cur.Exists) { return $false }
    switch ($r.Kind) {
        'DWord'       { return ($cur.Kind -eq 'DWord') -and (([int64]$cur.Value -band 4294967295) -eq ([int64]$r.Value -band 4294967295)) }
        'String'      { return ($cur.Kind -eq 'String') -and ("$($cur.Value)" -eq "$($r.Value)") }
        'MultiString' { return ($cur.Kind -eq 'MultiString') -and ((@($cur.Value) -join "`n") -eq (@($r.Value) -join "`n")) }
        'Binary'      { return ($cur.Kind -eq 'Binary') -and ((@($cur.Value) -join ',') -eq (@($r.Value) -join ',')) }
    }
    return $false
}
# 항목 하나의 지금 상태: Ok(원하는 상태와 같음) / Now(지금) / Target(바뀔 상태)
function Get-ItemState($r, [string]$root) {
    $cur = Get-RegValue $root $r.Key $r.Name
    switch ($r.Kind) {
        'DeleteKey'   { $ok = -not $cur.KeyExists; $now = if ($cur.KeyExists) { '키 있음' } else { '키 없음' }; $tgt = '키 지움' }
        'EnsureKey'   { $ok = [bool]$cur.KeyExists; $now = if ($cur.KeyExists) { '키 있음' } else { '키 없음' }; $tgt = '키 만듦' }
        'DeleteValue' { $ok = -not $cur.Exists; $now = Format-Cur $cur $null; $tgt = '지움' }
        'Track'       { $ok = $true; $now = Format-Cur $cur $null; $tgt = '' }
        default       { $ok = Test-SameValue $cur $r; $now = Format-Cur $cur $r.Kind; $tgt = Format-Shown $r.Value }
    }
    if ($cur.Error) { $ok = $false; $now = "읽을 수 없음 ($($cur.Error))" }
    [pscustomobject]@{ Ok = [bool]$ok; Now = $now; Target = $tgt }
}
function Write-RegFile([string]$path, [string[]]$lines) {
    # .reg 는 UTF-16 (BOM 포함)
    Write-TextFile $path ("Windows Registry Editor Version 5.00`r`n`r`n" + (@($lines) -join "`r`n") + "`r`n") 'utf16'
}
# 가져오기 (일부 키가 막혀도 나머지는 들어감. 결과는 Code·Text 로 돌려주고, 실제 값은 Test-RegApplied 로 확인)
function Import-Reg([string]$path) { Invoke-RegTool @('import', $path) }
# 적용 뒤 실제 값 확인. 안 맞으면 한 번 더 직접 써 보고, 그래도 안 되면 이유와 함께 알림. 반환: 안 맞는 개수
function Test-RegApplied($items, [switch]$Default) {
    $bad = 0
    foreach ($r in $items) {
        if ($r.Kind -eq 'Track') { continue }
        $root = Get-RootName $r.Hive -Default:$Default
        if ((Get-ItemState $r $root).Ok) { continue }
        $why = ''
        try {
            switch ($r.Kind) {
                'DeleteValue' { Remove-RegValueDirect $root $r.Key $r.Name }
                'EnsureKey'   { Set-RegDirect $root $r.Key '__lite_tmp' 'String' ''; Remove-RegValueDirect $root $r.Key '__lite_tmp' }
                'DeleteKey'   { $why = '가져오기로 지워지지 않음' }
                default       { Set-RegDirect $root $r.Key $r.Name $r.Kind $r.Value }
            }
            Start-Sleep -Milliseconds 300
            if (-not $why -and -not (Get-ItemState $r $root).Ok) { $why = "직접 써도 곧바로 '$((Get-ItemState $r $root).Now)' 로 되돌아감 (Windows 나 다른 프로그램이 관리하는 값)" }
        } catch { $why = $_.Exception.Message.Trim() }
        if ((Get-ItemState $r $root).Ok) { continue }
        $bad++
        Warn ("적용 안 됨: $($r.Desc) ($root\$($r.Key)$(if ($r.Name) { " $($r.Name)" }))" + $(if ($why) { " - $why" }))
    }
    return $bad
}
# 항목들을 .reg 줄로 (키별로 묶음)
function Build-ApplyLines($items, [switch]$Default) {
    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($g in (@($items) | Where-Object Kind -ne 'Track' | Group-Object { "$($_.Hive)|$($_.Key)" })) {
        $first = $g.Group[0]
        $path  = (Get-RootName $first.Hive -Default:$Default) + '\' + $first.Key
        $vals  = @($g.Group | Where-Object { $_.Kind -in 'DWord', 'String', 'MultiString', 'Binary', 'DeleteValue' })
        if ($g.Group | Where-Object Kind -eq 'DeleteKey') { $lines.Add("[-$path]"); $lines.Add('') }
        if ($vals.Count -or ($g.Group | Where-Object Kind -eq 'EnsureKey')) {
            $lines.Add("[$path]")
            foreach ($v in $vals) {
                if ($v.Kind -eq 'DeleteValue') { $lines.Add((Format-RegName $v.Name) + '=-') }
                else { $lines.Add((Format-RegLine $v.Name $v.Kind $v.Value)) }
            }
            $lines.Add('')
        }
    }
    return ,$lines.ToArray()
}
# 되돌리기용 .reg 줄: 원래 값이 있었으면 그 값(종류 그대로), 없었으면 지우기
# (키를 지우는 항목은 내보낸 파일로 따로 복원, 새로 생긴 키는 state.json 의 NewKeys 로 정리)
function Build-UndoLines($items, [switch]$Default) {
    $lines = New-Object System.Collections.Generic.List[string]
    foreach ($g in (@($items) | Where-Object { $_.Kind -notin 'DeleteKey', 'EnsureKey' } | Group-Object { "$($_.Hive)|$($_.Key)" })) {
        $first = $g.Group[0]
        $root  = Get-RootName $first.Hive -Default:$Default
        $lines.Add("[$root\$($first.Key)]")
        foreach ($v in $g.Group) {
            $cur = Get-RegValue $root $v.Key $v.Name
            if ($cur.Error) { throw "백업할 값을 읽지 못했어요: $root\$($v.Key) $($v.Name) ($($cur.Error))" }
            if (-not $cur.Exists) { $lines.Add((Format-RegName $v.Name) + '=-'); continue }
            if ($cur.Kind -notin 'DWord', 'QWord', 'String', 'ExpandString', 'MultiString', 'Binary', 'None') {
                throw "되돌리기용으로 저장할 수 없는 값 종류($($cur.Kind)): $root\$($v.Key) $($v.Name)"
            }
            $lines.Add((Format-RegLine $v.Name $cur.Kind $cur.Value))
        }
        $lines.Add('')
    }
    return ,$lines.ToArray()
}
# 적용 전에 없던 키 (되돌릴 때 비어 있으면 지움). 위쪽으로 올라가며 없는 키를 모두 기록. 형식: '루트|키'
function Get-NewKeys($items, [switch]$Default) {
    $out = New-Object System.Collections.Generic.List[string]
    foreach ($g in (@($items) | Where-Object Kind -ne 'DeleteKey' | Group-Object { "$($_.Hive)|$($_.Key)" })) {
        $root = Get-RootName $g.Group[0].Hive -Default:$Default
        $key  = $g.Group[0].Key
        while ($key -and -not (Get-RegValue $root $key '').KeyExists) {
            $id = "$root|$key"
            if (-not ($out | Where-Object { $_ -eq $id })) { $out.Add($id) }
            $i = $key.LastIndexOf('\'); if ($i -lt 1) { break }
            $key = $key.Substring(0, $i)
        }
    }
    return ,$out.ToArray()
}
function Remove-NewKeys($ids) {
    $n = 0
    foreach ($id in (@($ids) | Where-Object { $_ } | Sort-Object { ($_ -split '\\').Count } -Descending)) {
        $root, $key = $id -split '\|', 2
        try { if (Remove-RegKeyIfEmpty $root $key) { $n++ } } catch {}
    }
    return $n
}

# 새 사용자 기본값 하이브 불러오기/내리기
function Mount-DefaultHive {
    if (Test-HiveLoaded $DefHive) {
        # 지난번 실행이 중간에 멈춰 하이브가 걸려 있으면 내렸다가 다시 불러옴 (안 내려지면 그대로 씀)
        $null = Invoke-Reg @('unload', "HKU\$DefHive")
        if (Test-HiveLoaded $DefHive) { return $true }
    }
    if (-not (Test-Path -LiteralPath $script:DefaultNtUser)) { Warn "새 사용자 기본값($($script:DefaultNtUser))을 찾지 못해 새 사용자 쪽은 건너뜀"; return $false }
    $r = Invoke-Reg @('load', "HKU\$DefHive", $script:DefaultNtUser)
    if ($r.Code -ne 0 -or -not (Test-HiveLoaded $DefHive)) { Warn "새 사용자 기본값을 불러오지 못해 새 사용자 쪽은 건너뜀 ($($r.Text))"; return $false }
    return $true
}
function Dismount-DefaultHive {
    # 방금 쓴 핸들이 풀리도록 정리하고 아주 잠깐 기다린 뒤 시도 (첫 시도부터 2초씩 멈추지 않게 점점 길게)
    [GC]::Collect(); [GC]::WaitForPendingFinalizers(); Start-Sleep -Milliseconds 300
    $waits = @(300, 500, 1000, 2000, 2000)
    for ($i = 0; $i -lt $waits.Count; $i++) {
        $null = Invoke-Reg @('unload', "HKU\$DefHive")
        if (-not (Test-HiveLoaded $DefHive)) { return }
        Start-Sleep -Milliseconds $waits[$i]
    }
    Warn "새 사용자 기본값 하이브를 내리지 못했어요 (HKU\$DefHive). 다시 시작하면 풀려요."
}

# ============================== 앱 ==============================
# 빌드에서 지우는 목록 + 위젯. 아래 '추가 후보'는 설치돼 있을 때만 목록에 보임. 기본은 모두 체크 안 함
$AppCatalog = @(
    @('Microsoft.Paint', '그림판'), @('Microsoft.ZuneMusic', '미디어 플레이어 (새)'), @('Microsoft.WindowsAlarms', '알람 및 시계'),
    @('Microsoft.WindowsSoundRecorder', '녹음기'), @('Microsoft.MicrosoftStickyNotes', '스티커 메모'),
    @('MicrosoftCorporationII.QuickAssist', '빠른 지원'), @('Microsoft.WindowsCamera', '카메라'),
    @('Microsoft.OutlookForWindows', 'Outlook (new)'), @('MSTeams', 'Teams'), @('Microsoft.Todos', 'Microsoft To Do'),
    @('Microsoft.MicrosoftOfficeHub', 'Microsoft 365 (Office) 허브'), @('Microsoft.PowerAutomateDesktop', 'Power Automate'),
    @('Microsoft.Windows.DevHome', 'Dev Home'), @('Clipchamp.Clipchamp', 'Clipchamp (동영상 편집)'),
    @('Microsoft.BingNews', '뉴스'), @('Microsoft.BingWeather', '날씨'), @('Microsoft.BingSearch', 'Bing 검색'),
    @('Microsoft.GetHelp', '도움말 보기'), @('Microsoft.WindowsFeedbackHub', '피드백 허브'),
    @('Microsoft.MicrosoftSolitaireCollection', 'Solitaire'), @('MicrosoftCorporationII.MicrosoftFamily', 'Family Safety'),
    @('Microsoft.GamingApp', 'Xbox 앱'), @('Microsoft.XboxGamingOverlay', 'Xbox Game Bar'),
    @('Microsoft.XboxIdentityProvider', 'Xbox 로그인 구성요소 (게임·Xbox 앱 로그인에 필요)'),
    @('Microsoft.XboxSpeechToTextOverlay', 'Xbox 음성 텍스트 변환'), @('MicrosoftWindows.Client.WebExperience', '위젯')
) | ForEach-Object { [pscustomobject]@{ Name = $_[0]; Label = $_[1]; Group = '빌드 목록' } }
$AppExtra = @(
    @('Microsoft.Copilot', 'Copilot 앱'), @('Microsoft.549981C3F5F10', 'Cortana'), @('Microsoft.MicrosoftJournal', 'Journal'),
    @('Microsoft.People', '사람'), @('Microsoft.WindowsMaps', '지도'), @('microsoft.windowscommunicationsapps', '메일 및 일정 (옛)'),
    @('Microsoft.SkypeApp', 'Skype'), @('Microsoft.ZuneVideo', '영화 및 TV'), @('Microsoft.MixedReality.Portal', '혼합 현실 포털'),
    @('Microsoft.Microsoft3DViewer', '3D 뷰어'), @('Microsoft.Office.OneNote', 'OneNote for Windows 10'),
    @('MicrosoftTeams', 'Teams (개인용, 옛)'),
    @('Microsoft.MicrosoftPCManager', 'PC Manager'), @('SpotifyAB.SpotifyMusic', 'Spotify'), @('Disney.37853FC22B2CE', 'Disney+'),
    @('BytedancePte.Ltd.TikTok', 'TikTok'), @('Facebook.InstagramBeta', 'Instagram'), @('FACEBOOK.317180B0BB486', 'Messenger'),
    @('7EE7776C.LinkedInforWindows', 'LinkedIn'), @('4DF9E0F8.Netflix', 'Netflix'), @('AmazonVideo.PrimeVideo', 'Prime Video'),
    @('king.com.CandyCrushSaga', 'Candy Crush Saga'), @('king.com.CandyCrushSodaSaga', 'Candy Crush Soda Saga')
) | ForEach-Object { [pscustomobject]@{ Name = $_[0]; Label = $_[1]; Group = '추가 후보' } }
# 아예 건드리지 않는 앱: 고르는 창에도 안 보이고, 지우지도, 다시 생겨도 알리지도 않음
# (Edge Game Assist: Edge 가 설치·업데이트 때 계속 다시 까는 앱이라 지워도 소용없음 → 그냥 둠)
$AppIgnore = @('Microsoft.Edge.GameAssist')

function Get-AppLabel([string]$name) {
    $a = @($AppCatalog) + @($AppExtra) | Where-Object Name -eq $name | Select-Object -First 1
    if ($a) { $a.Label } else { $name }
}
# Get-AppxPackage 는 디스크/DB I/O 가 커서 한 실행 안에서 한 번만 조회해 재사용 (앱을 지운 뒤에는 Clear-AppxCache 로 비움)
function Clear-AppxCache { $script:_axAll = $null; $script:_axCur = $null; $script:_startNames = $null; $script:_axTasks = $null }
# 주의: 결과를 풀어서 내보냄 (return ,$x 로 내보내면 부르는 쪽 @() 이 '목록 하나짜리 목록'이 돼서 필터가 전부 빗나감)
function Get-AppxAll { if ($null -eq $script:_axAll) { $script:_axAll = @(Get-AppxPackage -AllUsers -ErrorAction Stop) }; $script:_axAll }
function Get-AppxCur { if ($null -eq $script:_axCur) { $script:_axCur = @(Get-AppxPackage -ErrorAction Stop) }; $script:_axCur }

# 새 사용자용(프로비저닝) 기록의 실제 파일이 남아 있는지 (없으면 새 사용자에게 설치될 수 없음)
function Test-ProvFiles($p) {
    $loc = [Environment]::ExpandEnvironmentVariables("$($p.InstallLocation)")
    if (-not $loc) { return $true }
    return (Test-Path -LiteralPath $loc)
}
function Get-AppStatus {
    $users = @(); $prov = @()
    try { $users = @(Get-AppxAll) } catch { Warn "설치된 앱 목록을 읽지 못했어요: $($_.Exception.Message)" }
    try { $prov = @(Get-AppxProvisionedPackage -Online -ErrorAction Stop) } catch { Warn "새 사용자용 앱 목록을 읽지 못했어요: $($_.Exception.Message)" }
    foreach ($a in @($AppCatalog) + @($AppExtra)) {
        if ($AppIgnore -contains $a.Name) { continue }   # 아예 건드리지 않는 앱 (창에도 안 보임)
        $u = @($users | Where-Object Name -eq $a.Name)
        $p = @($prov  | Where-Object DisplayName -eq $a.Name)
        if (-not $u.Count -and -not $p.Count) { continue }
        [pscustomobject]@{
            Name = $a.Name; Label = $a.Label; Group = $a.Group
            Installed = [bool]$u.Count; Provisioned = [bool]$p.Count
            ProvFiles = [bool]($p | Where-Object { Test-ProvFiles $_ })
            Version = if ($u.Count) { "$($u[0].Version)" } else { "$($p[0].Version)" }
        }
    }
}
function Get-AppStateText($a) {
    if ($a.Installed) { '설치됨' } elseif ($a.ProvFiles) { '새 사용자용으로만 남아 있음' } else { '새 사용자용 기록만 (파일 없음, 설치 안 됨)' }
}
function Read-NameList([string]$path) {
    if (-not (Test-Path -LiteralPath $path)) { return ,@() }
    return ,@((Read-TextFile $path) -split "\r?\n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -and $_ -notmatch '^#' })
}
# 고른 앱. 아직 안 골랐으면 $null, 골랐는데 없으면 빈 목록
function Read-Selection {
    if (-not (Test-Path -LiteralPath $script:SelFile)) { return $null }
    return ,(Read-NameList $script:SelFile)
}
function Save-Selection([string[]]$names) {
    $lines = @("# 지울 앱 ($(Get-Date -Format 'yyyy-MM-dd HH:mm')). 다시 고르려면 메뉴 1(미리보기)을 다시 실행하세요.") + @($names | Where-Object { $_ })
    Write-TextFile $script:SelFile (($lines -join "`r`n") + "`r`n")
}

# ============================== 무엇을 적용할지 (창에서 고르기) ==============================
$OptLabels = [ordered]@{
    Apps             = '앱 삭제 (다음 창에서 지울 앱을 하나씩 고름)'
    SystemComponents = '시스템 구성요소 삭제 (IE·옛 미디어 플레이어·PowerShell ISE·단계 레코더·수학 입력판·Recall)'
    Settings         = '설정·정책 (광고·추천·AI·원격 분석 끄기, 잠금 화면 없애기, 탐색기·백그라운드 등)'
    Startup          = '시작 프로그램 정리 (다음 창에서 로그인할 때 자동으로 켜질 프로그램을 고름)'
    DefenderScan     = '[베타기능] Defender 예약 검사 가볍게 (체크하면 다음 창에서 이 PC 에 맞는지 알려 주고 할지 물어봄. 실시간 보호는 그대로)'
    UpdateLock       = '업데이트 잠금 (자동 업데이트 끄기·현재 버전 고정·바탕화면 켜기/끄기)'
    OneDrive         = 'OneDrive 제거 (PC·클라우드의 파일은 지우지 않음)'
    DarkMode         = '다크 모드'
}
function New-DefaultFlags { $f = [ordered]@{}; foreach ($k in $Do.Keys) { $f[$k] = [bool]$Do[$k] }; return $f }
function Read-Options {
    if (-not (Test-Path -LiteralPath $script:OptFile)) { return $null }
    $f = New-DefaultFlags
    foreach ($l in (Read-NameList $script:OptFile)) {
        if ($l -match '^(\w+)\s*=\s*([01])$' -and $f.Contains($Matches[1])) { $f[$Matches[1]] = ($Matches[2] -eq '1') }
    }
    return $f
}
function Save-Options($flags) {
    $lines = @("# 적용할 항목 ($(Get-Date -Format 'yyyy-MM-dd HH:mm')). 다시 고르려면 메뉴 1(미리보기)을 다시 실행하세요.") +
             @($flags.Keys | ForEach-Object { "$_=$(if ($flags[$_]) { 1 } else { 0 })" })
    Write-TextFile $script:OptFile (($lines -join "`r`n") + "`r`n")
}
# 적용할 항목 고르는 창. 확인 → 고른 flags, 취소·닫기 → $null
function Show-SettingsPicker($current) {
    $p = New-PickerForm '무엇을 적용할까요 - BeSffy' "적용할 항목만 체크하세요. (이 PC 에 맞게 고르면 돼요)`n취소하면 이번 작업을 멈추고 아무것도 저장하지 않아요." 640 420
    $f = $p.Form; $list = $p.List
    $keys = @($OptLabels.Keys)
    foreach ($k in $keys) { $i = $list.Items.Add($OptLabels[$k]); $list.SetItemChecked($i, [bool]$current[$k]) }
    [void](Add-PickerButton $p 'Right' '확인' 'OK')
    [void](Add-PickerButton $p 'Right' '취소' 'Cancel')
    $res = Show-PickerForm $p
    $out = New-DefaultFlags
    foreach ($k in @($out.Keys)) { if ($current.Contains($k)) { $out[$k] = [bool]$current[$k] } }   # 목록에 없는 항목(검색 색인)은 그대로
    for ($i = 0; $i -lt $keys.Count; $i++) { $out[$keys[$i]] = $list.GetItemChecked($i) }
    $f.Dispose()
    if ("$res" -ne 'OK') { return $null }
    return $out
}

# ============================== 검색 색인 (따로 크게 고르기) ==============================
$SearchNotice = '※ 검색 색인을 끄면 Windows 안에서 검색(시작 메뉴·파일 탐색기·설정·Outlook 메일 등)이 제대로 되지 않을 수 있어요. 검색을 자주 쓰면 "켜 두기"를 고르세요. 끈 뒤에도 메뉴 5(일부 옵션만 복구)에서 다시 켤 수 있어요.'
# 확인 → $true(끄기) / $false(켜 두기), 취소·닫기 → $null
function Show-SearchPicker([bool]$off, [string]$nowText) {
    $p = New-PickerForm '검색 색인 - BeSffy' "Windows 검색 색인(WSearch)을 끌지 켜 둘지 고르세요.`n지금 이 PC: $nowText" 620 420 -Notice $SearchNotice -Radio @(
        "검색 색인 끄기  (PC 가 조금 가벼워져요)`n대신 시작 메뉴·파일 탐색기·설정·Outlook 등의 검색이`n느려지거나 결과가 덜 나올 수 있어요.",
        "검색 색인 켜 두기  (Windows 기본)`n파일·메일 검색을 자주 쓰면 이쪽을 고르세요.`n지금 꺼져 있으면 적용할 때 다시 켜요.")
    $p.Radios[0].Checked = $off; $p.Radios[1].Checked = (-not $off)
    [void](Add-PickerButton $p 'Right' '확인' 'OK')
    [void](Add-PickerButton $p 'Right' '취소' 'Cancel')
    $res = Show-PickerForm $p
    $out = [bool]$p.Radios[0].Checked
    $p.Form.Dispose()
    if ("$res" -ne 'OK') { return $null }
    return $out
}
# 미리보기(또는 아직 안 골랐을 때 적용)의 검색 색인 단계: $flags.DisableSearch 를 바꿈
# 돌려줌: 골랐거나 건너뛰었으면 $true, 창에서 취소했으면 $false (부르는 쪽이 작업 전체를 멈춤)
function Select-SearchOption($flags) {
    Head '검색 색인 (끄기 / 켜 두기)'
    if (-not (Get-Service -Name WSearch -ErrorAction SilentlyContinue)) { Say '  이 PC 에는 검색 서비스(WSearch)가 없어서 건너뛰어요.'; $flags['DisableSearch'] = $false; return $true }
    $nowOff = (Get-ScTypeFromRegistry 'WSearch') -eq 'disabled'
    $nowText = if ($nowOff) { '검색 색인 꺼져 있음' } else { '검색 색인 켜져 있음' }
    Say "  검색 색인을 끌지 고르는 창이 열려요. (지금: $nowText)"
    $r = Show-SearchPicker ([bool]$flags.DisableSearch) $nowText
    if ($null -eq $r) { Say '  검색 색인 고르기를 취소했어요.'; return $false }
    $flags['DisableSearch'] = [bool]$r
    Say "  검색 색인: $(if ($r) { '끄기' } elseif ($nowOff) { '켜 두기 (지금 꺼져 있어서 적용하면 다시 켜요)' } else { '켜 두기' })"
    return $true
}

# ============================== 백그라운드 예외 (창에서 고르기) ==============================
# 휴대폰과 연결은 항상 예외 (알림·메시지를 받아야 하므로)
$BgAlways = @('Microsoft.YourPhone_8wekyb3d8bbwe', 'MicrosoftWindows.CrossDevice_cw5n1h2txyewy')
# 백그라운드 금지 대상이 될 수 있는, 이 PC 에 설치된 스토어 앱 (프레임워크·핵심 시스템 앱은 뺌)
# 백그라운드 금지 정책은 PC 전체(HKLM)에 걸리므로 모든 사용자의 앱을 봄 (관리자 계정을 따로 써서 올려 실행해도 맞게).
# 모든 사용자 목록을 못 읽으면 지금 사용자 것만. 그것도 못 읽으면 빈 목록 + $script:BgReadError 에 이유
# -Detail: 알기 쉬운 이름(Label)·프로그램 묶음(Group)까지 (시작 메뉴를 읽어서 조금 느림 → 창·보고서에서만)
function Get-BgCandidates([switch]$Detail) {
    $script:BgReadError = $null
    $pk = @()
    try { $pk = @(Get-AppxAll) }
    catch {
        $e1 = $_.Exception.Message
        try { $pk = @(Get-AppxCur) } catch { $script:BgReadError = "$e1 / $($_.Exception.Message)" }
    }
    @($pk | Where-Object {
        $_ -and -not $_.IsFramework -and "$($_.SignatureKind)" -eq 'Store' -and $BgAlways -notcontains "$($_.PackageFamilyName)" -and $AppIgnore -notcontains "$($_.Name)" -and
        $_.Name -notmatch '^(Microsoft\.(WindowsStore|DesktopAppInstaller|StorePurchaseApp|Services\.Store|VCLibs|UI\.Xaml|NET\.|WindowsAppRuntime|SecHealthUI|LockApp|Windows\.(StartMenuExperienceHost|ShellExperienceHost|Search|CloudExperienceHost)))' -and
        $_.Name -notmatch 'VideoExtension|ImageExtension|MediaExtension|LanguageExperiencePack|Ink\.Handwriting|WindowsAppRuntime'
    } | ForEach-Object {
        $kind = Get-BgKind "$($_.Name)"
        $o = [pscustomobject]@{ Name = "$($_.Name)"; Family = "$($_.PackageFamilyName)"; Publisher = "$($_.Publisher)"; Kind = $kind; Rec = [bool]$kind; Label = "$($_.Name)"; Group = '' }
        if ($Detail) { $o.Label = Get-BgLabel $o.Name $o.Family; $o.Group = Get-BgGroup $o.Name $o.Publisher $o.Label }
        $o
    } | Sort-Object Name -Unique)
}
# 고른 백그라운드 예외. 아직 안 골랐으면 $null
# 빈 목록인데 '일부러 비움(#NONE)' 표시가 없으면 고르지 않은 걸로 봄 → 추천 기본값
# (v16 은 고르는 창이 빈칸으로 떠서, 확인만 눌러도 빈 목록이 저장됐음. 그대로 쓰면 제조사·오디오 도우미까지 백그라운드가 막힘)
function Read-BgSelection {
    if (-not (Test-Path -LiteralPath $script:BgFile)) { return $null }
    $l = Read-NameList $script:BgFile
    if (-not @($l).Count -and (Read-TextFile $script:BgFile) -notmatch '(?m)^#NONE') { $script:BgEmptyLegacy = $true; return $null }
    return ,$l
}
function Save-BgSelection([string[]]$families) {
    $fam = @($families | Where-Object { $_ })
    $lines = @("# 백그라운드를 계속 허용할 앱 (패키지 패밀리 이름). $(Get-Date -Format 'yyyy-MM-dd HH:mm')") + $fam
    if (-not $fam.Count) { $lines += '#NONE (일부러 아무것도 고르지 않음: 휴대폰과 연결 말고는 모두 백그라운드 금지)' }
    Write-TextFile $script:BgFile (($lines -join "`r`n") + "`r`n")
}
# 백그라운드 허용 고르는 창의 노란 안내 ($defaults: '추천만 켜기' 버튼이 체크할 것)
$BgNotice = '※ 클라우드 동기화(iCloud·Dropbox 등), 파일 공유(퀵쉐어 등), 메신저·메일(WhatsApp·Outlook 등)처럼 백그라운드에서 돌아야 하는 프로그램은 백그라운드를 끄면 제대로 동작하지 않을 수 있어요. (마이크로소프트 스토어에서 설치한 것만 해당. 일반 설치 프로그램은 영향 없음)'
# 묶음의 체크·표시를 하위 항목에 맞춤: 모두 켜져 있으면 체크, 아니면 체크 해제 + [켜 둠 n/m]
function Update-BgParent($node) {
    $on = 0; foreach ($c in $node.Nodes) { if ($c.Checked) { $on++ } }
    $star = if ($node.Tag -eq 'rec') { '   ★' } else { '' }
    $node.Text = '{0}   [켜 둠 {1}/{2}]{3}' -f $node.Name, $on, $node.Nodes.Count, $star
    $want = ($on -eq $node.Nodes.Count)
    if ($node.Checked -ne $want) { $node.Checked = $want }   # 코드로 바꾼 체크는 AfterCheck 에서 무시됨 (Action = Unknown)
}
# 트리의 맨 아래 항목(패밀리 이름이 Tag)을 조건대로 체크하고 묶음 표시를 맞춤
function Set-BgTreeChecked($tree, [scriptblock]$want) {
    foreach ($n in $tree.Nodes) {
        if ($n.Nodes.Count) { foreach ($c in $n.Nodes) { $c.Checked = [bool](& $want $c.Tag) }; Update-BgParent $n }
        else { $n.Checked = [bool](& $want $n.Tag) }
    }
}
function Get-BgTreeChecked($tree) {
    $out = @()
    foreach ($n in $tree.Nodes) {
        if ($n.Nodes.Count) { foreach ($c in $n.Nodes) { if ($c.Checked) { $out += "$($c.Tag)" } } }
        elseif ($n.Checked) { $out += "$($n.Tag)" }
    }
    return ,$out
}
# 백그라운드 허용 고르는 창 (미리보기의 '예외 고르기'와 메뉴 5 '다시 켜기'가 같은 창을 씀: 노란 안내 + 프로그램별 묶음)
# 프로그램을 체크하면 그 아래가 모두 같이 켜지고 꺼짐. 체크 = 백그라운드 켜 둠(허용), 체크 해제 = 끔(금지)
# 확인 → 켜 둘 패밀리 이름 목록, 취소·닫기 → $null.  -Restore: 메뉴 5 (제목·첫 줄만 다름)
function Show-BgPicker($candidates, [string[]]$preselected, [string[]]$defaults, [switch]$Restore) {
    $title = if ($Restore) { '백그라운드 다시 켜기 - BeSffy' } else { '백그라운드 예외 고르기 - BeSffy' }
    $first = if ($Restore) { "지금 백그라운드가 막혀 있는 앱(서비스)은 체크가 풀려 있어요. 다시 켤 것을 체크하세요. 체크를 풀면 막혀요.`n" }
             else { "체크한 앱(서비스)만 백그라운드에서 계속 돌 수 있어요. 체크를 풀면 창을 닫았을 때 백그라운드 실행이 막혀요.`n" }
    $p = New-PickerForm $title ($first +
        "프로그램 이름을 체크하면 그 아래 항목이 모두 같이 켜지고, 풀면 모두 같이 꺼져요. 펼쳐서 하나씩 고를 수도 있어요.`n" +
        "★ = 꺼 두면 동기화·알림·공유가 안 될 수 있어서 켜 두기를 권하는 것$(if (-not $Restore) { ' (처음엔 미리 체크돼 있어요)' }). 휴대폰과 연결은 항상 켜져 있어 목록에 없어요.") 720 700 -Tree -Notice $BgNotice
    $f = $p.Form; $tree = $p.List
    $tree.BeginUpdate()
    # 순서: 모두 추천(★)인 프로그램 → 일부만 추천 → 추천 없음 (같은 순위는 이름순)
    $groups = @($candidates | Group-Object Group | Sort-Object @{ Expression = { $rc = @($_.Group | Where-Object Rec).Count; if ($rc -eq $_.Count) { 0 } elseif ($rc) { 1 } else { 2 } } }, Name)
    foreach ($g in $groups) {
        $items = @($g.Group | Sort-Object @{ Expression = { if ($_.Rec) { 0 } else { 1 } } }, Label)
        if ($items.Count -eq 1) {
            $a = $items[0]
            $t = if ($g.Name -and $g.Name -ne $a.Label) { "$($g.Name) > $($a.Label)" } else { $a.Label }
            if ($a.Rec) { $t += "   ★ $($a.Kind)" }
            $n = $tree.Nodes.Add($t); $n.Tag = $a.Family; $n.ToolTipText = "패키지: $($a.Family)"
            $n.Checked = ($preselected -contains $a.Family)
        } else {
            $pn = $tree.Nodes.Add($g.Name); $pn.Name = $g.Name
            $pn.Tag = if (@($items | Where-Object Rec).Count) { 'rec' } else { '' }
            $pn.ToolTipText = "$($items.Count)개 항목. 체크하면 모두 켜고, 풀면 모두 꺼요."
            foreach ($a in $items) {
                $t = $a.Label; if ($a.Rec) { $t += "   ★ $($a.Kind)" }
                $c = $pn.Nodes.Add($t); $c.Tag = $a.Family; $c.ToolTipText = "패키지: $($a.Family)"
                $c.Checked = ($preselected -contains $a.Family)
            }
            Update-BgParent $pn
            # 펼쳐 둠: 작은 묶음, 모두 추천인 묶음, 꺼져 있는 추천(★) 항목이 있는 묶음 (놓치지 않게)
            # 접어 둠: 추천 항목이 다 켜져 있는 큰 묶음 ([켜 둠 n/m] 으로 보임)
            $recOffHere = @($items | Where-Object { $_.Rec -and $preselected -notcontains $_.Family }).Count
            if ($items.Count -le 8 -or -not @($items | Where-Object { -not $_.Rec }).Count -or $recOffHere) { $pn.Expand() }
        }
    }
    if ($tree.Nodes.Count) { $tree.Nodes[0].EnsureVisible() }
    $tree.EndUpdate()
    # 사람이 체크를 바꾸면: 프로그램 → 아래 항목 모두 같이, 아래 항목 → 프로그램 표시 다시 계산
    $tree.Add_AfterCheck({
        param($sender, $e)
        if ($e.Action -eq [System.Windows.Forms.TreeViewAction]::Unknown) { return }
        $n = $e.Node
        if ($n.Nodes.Count) { foreach ($c in $n.Nodes) { $c.Checked = $n.Checked }; Update-BgParent $n }
        elseif ($n.Parent) { Update-BgParent $n.Parent }
    })
    (Add-PickerButton $p 'Left' '모두 켜기').Add_Click({ Set-BgTreeChecked $tree { $true } })
    (Add-PickerButton $p 'Left' '모두 끄기').Add_Click({ Set-BgTreeChecked $tree { $false } })
    (Add-PickerButton $p 'Left' '추천만 켜기').Add_Click({ Set-BgTreeChecked $tree { param($fam) $defaults -contains $fam } })
    [void](Add-PickerButton $p 'Right' '확인' 'OK')
    [void](Add-PickerButton $p 'Right' '취소' 'Cancel')
    $res = Show-PickerForm $p
    $picked = Get-BgTreeChecked $tree
    $f.Dispose()
    if ("$res" -ne 'OK') { return $null }
    return ,$picked
}

# ============================== 시작 프로그램 ==============================
# 작업 관리자 '시작 앱'과 같은 방식: 원래 항목(자동 실행 값·시작 폴더 파일·스토어 앱 시작 작업)은 그대로 두고 켜짐/꺼짐만 기록
$StartupApproved = 'Software\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved'
$StartupSrc = [ordered]@{
    'run|HKCU'    = @{ Hive = 'HKCU'; Key = 'Software\Microsoft\Windows\CurrentVersion\Run';             Appr = "$StartupApproved\Run";   Where = '자동 실행 (이 사용자)' }
    'run|HKLM'    = @{ Hive = 'HKLM'; Key = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Run';             Appr = "$StartupApproved\Run";   Where = '자동 실행 (모든 사용자)' }
    'run32|HKLM'  = @{ Hive = 'HKLM'; Key = 'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run'; Appr = "$StartupApproved\Run32"; Where = '자동 실행 (모든 사용자, 32비트)' }
    'folder|HKCU' = @{ Hive = 'HKCU'; Env = 'APPDATA';     Sub = 'Microsoft\Windows\Start Menu\Programs\Startup'; Appr = "$StartupApproved\StartupFolder"; Where = '시작 폴더 (이 사용자)' }
    'folder|HKLM' = @{ Hive = 'HKLM'; Env = 'ProgramData'; Sub = 'Microsoft\Windows\Start Menu\Programs\StartUp'; Appr = "$StartupApproved\StartupFolder"; Where = '시작 폴더 (모든 사용자)' }
}
# 켜짐/꺼짐 기록 값: 첫 바이트가 홀수면 꺼짐 (작업 관리자가 쓰는 형식. 뒤 8바이트는 끈 시각인데 0 이어도 됨)
$StartupOnBytes  = [byte[]](2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
$StartupOffBytes = [byte[]](3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
# 스토어 앱 시작 작업의 켜짐/꺼짐 (State: 1 사용자가 끔, 2 켬, 0·3 꺼짐, 4 정책으로 켬)
$AppxStartupKey = 'Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData'
# 꺼 두면 장치·보안 기능이 안 될 수 있어 켜 두기를 권하는 것 (★). 그 밖에 백그라운드 예외의 추천 종류(클라우드·메신저 등)도 ★
$StartupKeep = @('*SecurityHealth*', '*ctfmon*', '*RtkAud*', '*RtkNGUI*', '*Realtek*', '*RAVBg*', '*RAVCpl*', '*igfx*', '*NVIDIA*', '*nvtray*', '*NvBackend*',
                 '*\AMD\*', '*AMD Software*', '*AMDRS*', '*Radeon*', '*Synaptics*', '*SynTP*', '*ETDCtrl*', '*Elantech*', '*Logitech*', '*LogiOptions*', '*LGHUB*', '*Bluetooth*')
$StartupNotice = '※ 체크를 풀면 Windows 에 로그인할 때 자동으로 켜지지 않아요. 프로그램은 지워지지 않고, 필요할 때 직접 열면 돼요. ★ 표시(보안·드라이버·클라우드 동기화·메신저 등)는 끄면 알림·동기화가 안 되거나 장치 기능이 제대로 동작하지 않을 수 있어서 켜 두기를 권해요.'

function Get-StartupDir($s) { Join-Path ([Environment]::GetEnvironmentVariable($s.Env)) $s.Sub }
function Test-ApprovedOn($cur) { -not ($cur.Exists -and $cur.Kind -eq 'Binary' -and @($cur.Value).Count -and ($cur.Value[0] -band 1)) }
# 스토어 앱의 시작 작업 (매니페스트의 StartupTask). 한 작업 안에서 한 번만 읽음
function Get-AppxStartupTasks {
    if ($null -ne $script:_axTasks) { return $script:_axTasks }
    $out = New-Object System.Collections.Generic.List[object]
    $pk = @(); try { $pk = @(Get-AppxCur) } catch {}
    foreach ($p in $pk) {
        if ($p.IsFramework -or -not "$($p.InstallLocation)") { continue }
        $x = $null; try { $x = [IO.File]::ReadAllText((Join-Path "$($p.InstallLocation)" 'AppxManifest.xml')) } catch { continue }
        foreach ($t in [regex]::Matches($x, '<(?:\w+:)?StartupTask\b[^>]*>')) {
            $a = @{}; foreach ($g in [regex]::Matches($t.Value, '(\w+)="([^"]*)"')) { $a[$g.Groups[1].Value] = $g.Groups[2].Value }
            if (-not $a.TaskId) { continue }
            $out.Add([pscustomobject]@{ Family = "$($p.PackageFamilyName)"; Name = "$($p.Name)"; TaskId = $a.TaskId; Enabled = ($a.Enabled -eq 'true'); DisplayName = "$($a.DisplayName)" })
        }
    }
    $script:_axTasks = $out.ToArray()
    return $script:_axTasks
}
# id(종류|위치|이름) → 켜짐/꺼짐을 적는 곳, 원래 항목이 아직 있는지
function Get-StartupTarget([string]$id) {
    $p = $id -split '\|', 3
    if ($p.Count -lt 3) { return $null }
    if ($p[0] -eq 'appx') {
        $has = $true; try { $has = [bool](@(Get-AppxCur) | Where-Object PackageFamilyName -eq $p[1]) } catch {}
        return [pscustomobject]@{ Hive = 'HKCU'; Key = "$AppxStartupKey\$($p[1])\$($p[2])"; Name = 'State'; Kind = 'DWord'; On = 2; Off = 1; Exists = $has }
    }
    $s = $StartupSrc["$($p[0])|$($p[1])"]
    if (-not $s) { return $null }
    $has = if ($s.Key) { (Get-RegValue (Get-RootName $s.Hive) $s.Key $p[2]).Exists } else { Test-Path -LiteralPath (Join-Path (Get-StartupDir $s) $p[2]) }
    [pscustomobject]@{ Hive = $s.Hive; Key = $s.Appr; Name = $p[2]; Kind = 'Binary'; On = $StartupOnBytes; Off = $StartupOffBytes; Exists = [bool]$has }
}
# 지금 켜져 있는지 ($null = 원래 항목이 없음)
function Get-StartupNow([string]$id) {
    $t = Get-StartupTarget $id
    if (-not $t -or -not $t.Exists) { return $null }
    $cur = Get-RegValue (Get-RootName $t.Hive) $t.Key $t.Name
    if ($t.Kind -ne 'DWord') { return (Test-ApprovedOn $cur) }
    if ($cur.Exists) { return ((([int64]$cur.Value -band 4294967295) -in 2, 4)) }
    $p = $id -split '\|', 3
    return [bool](@(Get-AppxStartupTasks) | Where-Object { $_.Family -eq $p[1] -and $_.TaskId -eq $p[2] -and $_.Enabled })
}
# 알기 쉬운 이름: 실행 파일 설명(예: Realtek HD Audio ...)이 있으면 그걸 앞에
function Get-StartupLabel([string]$name, [string]$cmd) {
    $exe = if ($cmd -match '^\s*"([^"]+)"') { $Matches[1] } elseif ($cmd -match '^\s*([^"]+?\.exe)\b') { $Matches[1] } else { '' }
    if ($exe) {
        try {
            $f = [Environment]::ExpandEnvironmentVariables($exe)
            if (Test-Path -LiteralPath $f -PathType Leaf) { $d = "$((Get-Item -LiteralPath $f).VersionInfo.FileDescription)".Trim(); if ($d -and $d -ne $name) { return "$d ($name)" } }
        } catch {}
    }
    return $name
}
function Get-StartupKind([string]$text) {
    foreach ($pt in $StartupKeep) { if ($text -like $pt) { return '보안·장치' } }
    foreach ($w in ($text -split '[\s\\/"]+' | Where-Object { $_ })) { $k = Get-BgKind $w; if ($k) { return $k } }
    return ''
}
function New-StartupItem([string]$id, [string]$label, [string]$detail, [string]$where, [bool]$on, [string]$extra) {
    $kind = Get-StartupKind "$label $detail $extra"
    [pscustomobject]@{ Id = $id; Label = $label; Detail = $detail; Where = $where; On = $on; Rec = [bool]$kind; Kind = $kind }
}
# 이 PC 의 시작 프로그램 전부 (켜진 것·꺼진 것)
function Get-StartupItems {
    $out = New-Object System.Collections.Generic.List[object]
    foreach ($k in $StartupSrc.Keys) {
        $s = $StartupSrc[$k]; $root = Get-RootName $s.Hive
        if ($s.Key) {
            foreach ($n in @(Get-RegValueNames $root $s.Key)) {
                if (-not $n) { continue }
                $cmd = "$((Get-RegValue $root $s.Key $n).Value)"
                $out.Add((New-StartupItem "$k|$n" (Get-StartupLabel $n $cmd) $cmd $s.Where (Test-ApprovedOn (Get-RegValue $root $s.Appr $n)) $n))
            }
        } else {
            foreach ($f in @(Get-ChildItem -LiteralPath (Get-StartupDir $s) -File -Force -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne 'desktop.ini' })) {
                $tgt = if ($f.Extension -eq '.lnk') { Get-LnkTarget $f.FullName } else { $f.FullName }
                $out.Add((New-StartupItem "$k|$($f.Name)" (Get-StartupLabel $f.BaseName $(if ($tgt) { "`"$tgt`"" })) $tgt $s.Where (Test-ApprovedOn (Get-RegValue $root $s.Appr $f.Name)) $f.Name))
            }
        }
    }
    foreach ($t in @(Get-AppxStartupTasks)) {
        $st = Get-RegValue (Get-RootName 'HKCU') "$AppxStartupKey\$($t.Family)\$($t.TaskId)" 'State'
        $on = if ($st.Exists) { (([int64]$st.Value -band 4294967295) -in 2, 4) } else { $t.Enabled }
        $label = if ($t.DisplayName -and $t.DisplayName -notmatch '^ms-resource:') { $t.DisplayName } else { Get-BgLabel $t.Name $t.Family }
        $out.Add((New-StartupItem "appx|$($t.Family)|$($t.TaskId)" $label $t.Family '스토어 앱' $on $t.Name))
    }
    return $out.ToArray()   # 하나씩 내보냄 (부르는 쪽에서 @() 로 받음. ,배열 로 내보내면 @() 가 한 번 더 감싸 버림)
}
# 고른 값 파일: off/on <탭> id <탭> 이름. 아직 안 골랐으면 $null
function Read-StartupSelection {
    if (-not (Test-Path -LiteralPath $script:StartupFile)) { return $null }
    $out = @()
    foreach ($l in ((Read-TextFile $script:StartupFile) -split "\r?\n")) {
        if ($l -match '^(on|off)\t([^\t]+)\t?(.*)$') { $out += [pscustomobject]@{ Id = $Matches[2]; Want = ($Matches[1] -eq 'on'); Label = $Matches[3] } }
    }
    return ,$out
}
function Save-StartupSelection($plan) {
    $lines = @("# 시작 프로그램에서 바꿀 것 ($(Get-Date -Format 'yyyy-MM-dd HH:mm')). off = 로그인할 때 안 켜짐, on = 다시 켬. 다시 고르려면 메뉴 1(미리보기)을 다시 실행하세요.") +
             @(@($plan) | ForEach-Object { "$(if ($_.Want) { 'on' } else { 'off' })`t$($_.Id)`t$($_.Label)" })
    Write-TextFile $script:StartupFile (($lines -join "`r`n") + "`r`n")
}
# 창의 처음 체크: 지금 상태, 전에 골라 둔 것이 있으면 그 값
function Get-StartupWant($items, $saved) {
    $w = @{}; foreach ($it in $items) { $w[$it.Id] = [bool]$it.On }
    foreach ($c in @($saved)) { if ($c -and $w.ContainsKey($c.Id)) { $w[$c.Id] = [bool]$c.Want } }
    return $w
}
# 창에서 고른 것 중 지금 상태와 다른 것 = 바꿀 것
function Get-StartupChanges($items, $pick) {
    @($items | Where-Object { [bool]$pick[$_.Id] -ne [bool]$_.On } | ForEach-Object { [pscustomobject]@{ Id = $_.Id; Want = [bool]$pick[$_.Id]; Label = $_.Label } })
}
function Set-StartupPlan($plan) { $script:StartupPlan = @($plan); Build-RegItems }
# 시작 프로그램 고르는 창. $want: id → 켜 둘지. 확인 → 같은 형식의 새 표, 취소·닫기 → $null.  -Restore: 메뉴 5 (꺼진 것만, 체크 = 다시 켬)
function Show-StartupPicker($items, $want, [switch]$Restore) {
    $title = if ($Restore) { '시작 프로그램 다시 켜기 - BeSffy' } else { '시작 프로그램 고르기 - BeSffy' }
    $text = if ($Restore) { "지금 로그인할 때 켜지지 않는 프로그램이에요. 다시 켤 것만 체크하세요. (다음 로그인부터 자동으로 켜져요)" }
            else { "로그인할 때 자동으로 켜 둘 프로그램만 체크하세요. 지금 상태대로 체크돼 있어요.`n취소하면 이번 작업을 멈추고 아무것도 저장하지 않아요." }
    $p = New-PickerForm $title $text 720 660 -Notice $StartupNotice
    $f = $p.Form; $list = $p.List
    foreach ($it in $items) {
        $i = $list.Items.Add(("{0}{1}   [{2}]   {3}" -f $(if ($it.Rec) { '★ ' } else { '' }), $it.Label, $it.Where, $it.Detail))
        $list.SetItemChecked($i, [bool]$want[$it.Id])
    }
    (Add-PickerButton $p 'Left' '모두 켜기').Add_Click({ Set-AllChecked $list $true })
    (Add-PickerButton $p 'Left' '모두 끄기').Add_Click({ Set-AllChecked $list $false })
    (Add-PickerButton $p 'Left' '처음대로').Add_Click({ for ($i = 0; $i -lt $list.Items.Count; $i++) { $list.SetItemChecked($i, [bool]$want[$items[$i].Id]) } })
    [void](Add-PickerButton $p 'Right' '확인' 'OK')
    [void](Add-PickerButton $p 'Right' '취소' 'Cancel')
    $res = Show-PickerForm $p
    $out = @{}; for ($i = 0; $i -lt @($items).Count; $i++) { $out[$items[$i].Id] = [bool]$list.GetItemChecked($i) }
    $f.Dispose()
    if ("$res" -ne 'OK') { return $null }
    return $out
}

# ============================== Defender 예약 검사 ==============================
# 예약 검사가 CPU 를 평균 20% 까지만 쓰게 (기본 50%). Windows 기본값은 'PC 가 쉴 때는 제한 없이 검사'라 그것도 끔.
# 실시간 보호(파일을 열 때 검사)는 그대로라 보안은 같고, 예약 검사가 조금 더 오래 걸림
$DefenderWant = [ordered]@{ ScanAvgCPULoadFactor = 20; DisableCpuThrottleOnIdleScans = $false; EnableLowCpuPriority = $true }
function Test-DefenderWanted($p) { [bool]($p -and [int]$p.ScanAvgCPULoadFactor -eq 20 -and -not [bool]$p.DisableCpuThrottleOnIdleScans -and [bool]$p.EnableLowCpuPriority) }
function Format-DefenderPref($p) { "CPU 평균 $($p.ScanAvgCPULoadFactor)% / PC 가 쉴 때도 제한 $(YesNo (-not [bool]$p.DisableCpuThrottleOnIdleScans)) / 낮은 우선순위 $(YesNo ([bool]$p.EnableLowCpuPriority))" }
# 검사 한 번: 시작 시각, 걸린 시간 (끝 시각이 시작보다 앞이면 아직 검사 중이거나 중간에 멈춘 것)
function Get-ScanSeconds($a, $b) { if ($a -is [datetime] -and $b -is [datetime] -and $a.Year -ge 2000 -and $b -ge $a) { [int]($b - $a).TotalSeconds } }
function Format-Duration([int]$s) { "$(if ($s -ge 60) { "$([Math]::Floor($s / 60))분 " })$($s % 60)초" }
function Format-ScanRun($a, $b) {
    if (-not ($a -is [datetime]) -or $a.Year -lt 2000) { return '기록 없음' }
    $s = Get-ScanSeconds $a $b
    $a.ToString('yyyy-MM-dd HH:mm') + $(if ($null -ne $s) { ", $(Format-Duration $s) 걸림" })
}
# 이 PC 에 맞는지 (사람이 할지 말지 정할 수 있게 고르는 창·미리보기에 보여 줌). $p = Get-DefenderScanPref 결과
# 돌려줌: @{ Scan = 검사 기록 한 줄(못 읽으면 $null); Now = 지금 설정; Rec = 'on'(가볍게 추천) / 'off'(그대로 추천) / $null(모름); Hint = 이유 }
function Get-DefenderAdvice($p) {
    $st = $null; try { $st = Get-MpComputerStatus -ErrorAction Stop } catch {}
    $scan = $null; $sec = $null
    if ($st) {
        $scan = "마지막 빠른 검사: $(Format-ScanRun $st.QuickScanStartTime $st.QuickScanEndTime)  /  전체 검사: $(Format-ScanRun $st.FullScanStartTime $st.FullScanEndTime)"
        $sec = Get-ScanSeconds $st.QuickScanStartTime $st.QuickScanEndTime
    }
    # shortcut: 빠른 검사에 걸린 시간 하나로만 판단 (검사 중 CPU 사용률은 Windows 가 기록을 안 남김), 추천이 자주 틀린다는 말이 나오면 CPU 코어 수도 같이 봄
    $rec, $hint = if (Test-DefenderWanted $p) { 'on', '이미 가볍게 설정돼 있어요. 그대로 "가볍게 하기"를 고르면 돼요.' }
        elseif ($null -eq $sec) { $null, '검사에 걸린 시간을 알 수 없어서 이 PC 에 맞는지 판단하기 어려워요. 자리를 비웠을 때 팬이 자주 돌거나, 검사 중에 버벅인 적이 있으면 해 볼 만해요.' }
        elseif ($sec -le 60) { 'off', "이 PC 는 빠른 검사가 $(Format-Duration $sec) 만에 끝나서 가볍게 해도 체감 차이가 거의 없어요. '그대로 두기'를 권해요." }
        else { 'on', "이 PC 는 빠른 검사가 $(Format-Duration $sec) 걸려요. 가볍게 하면 검사하는 동안 덜 버벅여요. '가볍게 하기'를 권해요." }
    @{ Scan = $scan; Now = "지금: $(Format-DefenderPref $p)"; Rec = $rec; Hint = $hint }
}
# 확인 → $true(가볍게) / $false(그대로), 취소·닫기 → $null. 추천 쪽을 미리 골라 두고 '← 이 PC 에 추천' 표시 (추천이 없으면 체크한 대로 가볍게)
function Show-DefenderPicker($a) {
    $text = "[베타기능] Defender 예약 검사를 가볍게 할지 고르세요. 실시간 보호는 어느 쪽이든 그대로예요.`n" + ((@($a.Scan, $a.Now) | Where-Object { $_ }) -join "`n")
    $tagOn = if ($a.Rec -eq 'on') { '   ← 이 PC 에 추천' } else { '' }
    $tagOff = if ($a.Rec -eq 'off') { '   ← 이 PC 에 추천' } else { '' }
    $p = New-PickerForm '[베타기능] Defender 예약 검사 - BeSffy' $text 620 440 -Notice "※ $($a.Hint)" -Radio @(
        "가볍게 하기$tagOn`n예약 검사가 CPU 를 평균 20% 까지만 쓰고, PC 가 쉴 때도 제한해요.`n대신 검사가 조금 더 오래 걸려요.",
        "그대로 두기  (Windows 기본)$tagOff`nDefender 설정을 바꾸지 않아요.")
    $on = $a.Rec -ne 'off'
    $p.Radios[0].Checked = $on; $p.Radios[1].Checked = (-not $on)
    [void](Add-PickerButton $p 'Right' '확인' 'OK')
    [void](Add-PickerButton $p 'Right' '취소' 'Cancel')
    $res = Show-PickerForm $p
    $out = [bool]$p.Radios[0].Checked
    $p.Form.Dispose()
    if ("$res" -ne 'OK') { return $null }
    return $out
}
# 미리보기(또는 아직 안 골랐을 때 적용)에서 설정 창에 Defender 를 체크했으면, 이 PC 에 맞는지 알려 주고 할지 말지 고르게 함
# 돌려줌: 골랐거나 건너뛰었으면 $true, 창에서 취소했으면 $false (부르는 쪽이 작업 전체를 멈춤). Defender 를 못 읽으면 창 없이 넘어감 (적용할 때 건너뜀)
function Select-DefenderOption($flags) {
    if (-not $flags.DefenderScan) { return $true }
    $dp = Get-DefenderScanPref
    if ($null -eq $dp) { return $true }
    Head '[베타기능] Defender 예약 검사 (가볍게 / 그대로)'
    $a = Get-DefenderAdvice $dp
    Say "  이 PC 에 맞는지 알려 주는 창이 열려요. ($($a.Hint))"
    $r = Show-DefenderPicker $a
    if ($null -eq $r) { Say '  Defender 고르기를 취소했어요.'; return $false }
    $flags['DefenderScan'] = [bool]$r
    Say "  Defender 예약 검사: $(if ($r) { '가볍게 하기' } else { '그대로 두기 (적용할 항목에서 빠짐. Defender 는 건드리지 않음)' })"
    return $true
}
function Set-DefenderScan {
    try { Set-DefenderScanPref $DefenderWant } catch { Warn "Defender 예약 검사 설정을 바꾸지 못했어요: $("$($_.Exception.Message)".Trim())"; return }
    $p = Get-DefenderScanPref
    if (Test-DefenderWanted $p) { Say "  Defender 예약 검사: $(Format-DefenderPref $p)" }
    else { Warn "Defender 예약 검사 설정이 들어가지 않았어요 (지금: $(if ($p) { Format-DefenderPref $p } else { $script:DefenderErr })). 그룹 정책이나 다른 관리 도구가 정하고 있을 수 있어요." }
}

# ============================== 시스템 구성요소 ==============================
$CapPatterns = [ordered]@{
    'Browser.InternetExplorer*'         = 'Internet Explorer 구성요소 (Edge 의 IE 모드는 그대로)'
    'Media.WindowsMediaPlayer*'         = '옛 Windows Media Player'
    'Microsoft.Windows.PowerShell.ISE*' = 'PowerShell ISE'
    'App.StepsRecorder*'                = '단계 레코더'
    'MathRecognizer*'                   = '수학 입력판'
}
function Get-CapStatus {
    $caps = $null
    try { $caps = @(Get-WindowsCapability -Online -ErrorAction Stop) } catch { Warn "선택적 기능 목록을 읽지 못했어요: $($_.Exception.Message)" }
    foreach ($p in $CapPatterns.Keys) {
        $c = @($caps | Where-Object { $_ -and $_.Name -like $p }) | Select-Object -First 1
        $state = if ($null -eq $caps) { '확인 못 함' } elseif ($c) { "$($c.State)" } else { '없음' }
        [pscustomobject]@{ Pattern = $p; Label = $CapPatterns[$p]; Name = $c.Name; State = $state }
    }
}
function Get-RecallState {
    try { $rc = Get-WindowsOptionalFeature -Online -FeatureName Recall -ErrorAction Stop; if ($rc) { return "$($rc.State)" } } catch {}
    return '없음'
}

# ============================== OneDrive ==============================
function Get-OneDriveInfo([switch]$NoScan) {
    $uninst = @()
    foreach ($s in @(@('HKEY_CURRENT_USER', 'Software\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe', '사용자'),
                     @($HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe', 'PC 전체'),
                     @($HKLM, 'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe', 'PC 전체'))) {
        $cmd = Get-RegValue $s[0] $s[1] 'UninstallString'
        if ($cmd.Exists -and "$($cmd.Value)".Trim()) {
            $ver = Get-RegValue $s[0] $s[1] 'DisplayVersion'
            $uninst += [pscustomobject]@{ Scope = $s[2]; Cmd = "$($cmd.Value)"; Version = "$($ver.Value)" }
        }
    }
    $folder = $env:OneDrive
    if (-not $folder) { $folder = "$((Get-RegValue 'HKEY_CURRENT_USER' 'Software\Microsoft\OneDrive\Accounts\Personal' 'UserFolder').Value)" }
    # 'PC 폴더 백업'으로 OneDrive 안으로 옮겨진 폴더 (바탕 화면·문서·사진 등)
    $names = [ordered]@{ 'Desktop' = '바탕 화면'; 'Personal' = '문서'; 'My Pictures' = '사진'; 'My Music' = '음악'; 'My Video' = '동영상'
                         '{374DE290-123F-4565-9164-39C4925E467B}' = '다운로드' }
    $moved = @()
    foreach ($n in $names.Keys) {
        $v = Get-RegValue 'HKEY_CURRENT_USER' 'Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' $n
        $p = [Environment]::ExpandEnvironmentVariables("$($v.Value)")
        if ($p -and ($p -match '\\OneDrive' -or ($folder -and $p -like "$folder*"))) { $moved += "$($names[$n]) ($p)" }
    }
    $cloud = [pscustomobject]@{ Count = 0; Scanned = 0; Partial = $false }
    if ($uninst.Count -and -not $NoScan -and $folder -and (Test-Path -LiteralPath $folder)) { $cloud = Get-CloudOnlyCount $folder }
    [pscustomobject]@{
        Installed = [bool]$uninst.Count; Uninstall = $uninst; Running = (Test-OneDriveRunning)
        Folder = $folder; Moved = $moved; CloudOnly = $cloud.Count; Scanned = $cloud.Scanned; Partial = $cloud.Partial
    }
}

# ============================== 그 밖의 상태 ==============================
function Test-PendingReboot {
    (Get-RegValue $HKLM 'SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending' '').KeyExists -or
    (Get-RegValue $HKLM 'SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired' '').KeyExists
}
# 바꾸는 서비스: Sc = sc.exe 시작 유형, Want = Get-Service 에 보이는 이름, Stop = 지금 멈춤
function Get-ServicePlan($flags) {
    $p = @()
    if ($flags.Settings) {
        $p += [pscustomobject]@{ Name = 'DiagTrack'; Sc = 'disabled'; Want = 'Disabled'; Stop = $true }
        $p += [pscustomobject]@{ Name = 'WSAIFabricSvc'; Sc = 'demand'; Want = 'Manual'; Stop = $false }
    }
    if ($flags.DisableSearch) { $p += [pscustomobject]@{ Name = 'WSearch'; Sc = 'disabled'; Want = 'Disabled'; Stop = $true } }
    return $p
}
# 레지스트리 Start 값 → sc.exe 시작 유형
function Get-ScTypeFromRegistry([string]$name) {
    $k = "SYSTEM\CurrentControlSet\Services\$name"
    $s = Get-RegValue $HKLM $k 'Start'
    if (-not $s.Exists) { return $null }
    $d = Get-RegValue $HKLM $k 'DelayedAutostart'
    switch ([int]$s.Value) {
        2 { if ($d.Exists -and [int]$d.Value -eq 1) { return 'delayed-auto' } else { return 'auto' } }
        3 { return 'demand' }
        4 { return 'disabled' }
    }
    return $null
}
# 시작 메뉴의 명령 프롬프트·PowerShell 바로가기
function Get-ShellLinks {
    foreach ($d in $script:StartMenuDirs) {
        if (-not (Test-Path -LiteralPath $d)) { continue }
        Get-ChildItem -LiteralPath $d -Recurse -Filter '*.lnk' -File -Force -ErrorAction SilentlyContinue |
            Where-Object { (Get-LnkTarget $_.FullName) -match '\\(cmd|powershell|pwsh)\.exe$' }
    }
}
function Test-LnkRunAsSafe([string]$path) { try { Test-LnkRunAs $path } catch { $false } }

# 터미널 settings.json 은 주석(//, /* */)을 허용함. Windows PowerShell 5.1 의 ConvertFrom-Json 은 주석을 못 읽어서
# 문자열 밖의 주석만 지우고 읽음 (주소 안의 // 는 그대로)
function Remove-JsonComments([string]$s) {
    $sb = New-Object System.Text.StringBuilder $s.Length
    $i = 0; $inStr = $false
    while ($i -lt $s.Length) {
        $c = $s[$i]
        if ($inStr) {
            [void]$sb.Append($c)
            if ($c -eq '\' -and $i + 1 -lt $s.Length) { [void]$sb.Append($s[$i + 1]); $i += 2; continue }
            if ($c -eq '"') { $inStr = $false }
            $i++; continue
        }
        if ($c -eq '"') { $inStr = $true; [void]$sb.Append($c); $i++; continue }
        if ($c -eq '/' -and $i + 1 -lt $s.Length -and $s[$i + 1] -eq '/') {
            while ($i -lt $s.Length -and $s[$i] -ne "`n") { $i++ }
            continue
        }
        if ($c -eq '/' -and $i + 1 -lt $s.Length -and $s[$i + 1] -eq '*') {
            $e = $s.IndexOf('*/', $i + 2); if ($e -lt 0) { $i = $s.Length } else { $i = $e + 2 }
            continue
        }
        if ($c -eq ',') {
            # 끝에 붙은 쉼표 (터미널은 허용, ConvertFrom-Json 은 거부): 다음 글자가 ] 나 } 면 버림
            $j = $i + 1
            while ($j -lt $s.Length -and [char]::IsWhiteSpace($s[$j])) { $j++ }
            if ($j -lt $s.Length -and ($s[$j] -eq ']' -or $s[$j] -eq '}')) { $i++; continue }
        }
        [void]$sb.Append($c); $i++
    }
    return $sb.ToString()
}
function Read-TerminalSettings {
    $f = $script:TerminalFile
    if (-not (Test-Path -LiteralPath $f)) { return [pscustomobject]@{ Exists = $false; Json = $null; Error = $null } }
    try {
        $j = (Remove-JsonComments (Read-TextFile $f)) | ConvertFrom-Json -ErrorAction Stop
        if ($null -eq $j) { throw '빈 파일' }
        return [pscustomobject]@{ Exists = $true; Json = $j; Error = $null }
    } catch { return [pscustomobject]@{ Exists = $true; Json = $null; Error = $_.Exception.Message } }
}
function Get-ProfileName([string]$guid) { if ($ProfileNames.ContainsKey("$guid")) { "$($ProfileNames["$guid"])" } elseif ($guid) { $guid } else { '정해지지 않음' } }
function Test-TerminalInstalled { [bool](Get-AppxPackage -Name Microsoft.WindowsTerminal -ErrorAction SilentlyContinue) }

# ============================== 적용 기록 (백업 폴더) ==============================
function Get-Backups {
    @(Get-ChildItem -LiteralPath $script:BackupRoot -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '^\d{8}_\d{6}$' -and (Test-Path -LiteralPath (Join-Path $_.FullName 'state.json')) } |
        Sort-Object Name)
}
function Read-State([string]$bk) { (Read-TextFile (Join-Path $bk 'state.json')) | ConvertFrom-Json }
# 지금까지 적용한 것 (되돌리지 않은 백업 전부). 없으면 $null
function Get-AppliedInfo {
    $bks = @(Get-Backups)
    if (-not $bks.Count) { return $null }
    $flags = [ordered]@{}; foreach ($k in $Do.Keys) { $flags[$k] = $false }
    $apps = @(); $def = $false; $skippedOd = $false; $bgApps = $null; $su = [ordered]@{}
    foreach ($b in $bks) {
        $st = Read-State $b.FullName
        foreach ($k in @($flags.Keys)) {
            # 예전 형식 백업(Applied 없음): 그때 설정과 같다고 봄. 나중에 생긴 항목(시작 프로그램·Defender)은 그때 없었으니 안 한 것으로
            $v = if ($st.Applied -and $null -ne $st.Applied.$k) { [bool]$st.Applied.$k } elseif ($k -in 'Startup', 'DefenderScan') { $false } else { [bool]$Do[$k] }
            if ($v) { $flags[$k] = $true }
        }
        # 시작 프로그램: 적용마다 바꾼 것 (같은 항목은 나중 것이 지금 값)
        if ($st.PSObject.Properties['Startup']) { foreach ($c in @($st.Startup)) { if ($c -and $c.Id) { $su["$($c.Id)"] = [pscustomobject]@{ Id = "$($c.Id)"; Want = [bool]$c.Want; Label = "$($c.Label)" } } } }
        # 메뉴 5 로 검색 색인을 다시 켰으면 그 뒤로는 '검색 색인 끄기'를 점검하지 않음 (나중 적용에서 다시 끄면 다시 점검)
        if (Test-Path -LiteralPath (Join-Path $b.FullName 'search_on.txt')) { $flags['DisableSearch'] = $false }
        if ($st.DefaultUser) { $def = $true }
        if ($st.OneDriveSkipped) { $skippedOd = $true }
        # 백그라운드 예외 목록은 적용할 때마다 통째로 덮어쓰므로, 지금 레지스트리 = 마지막 적용의 목록
        if ($st.PSObject.Properties['BgApps']) { $bgApps = @($st.BgApps | Where-Object { $_ }) }
        # 메뉴 5 로 그 뒤에 바꾼 목록 (있으면 이게 지금 레지스트리)
        $ov = Join-Path $b.FullName 'bgapps_changed.txt'
        if (Test-Path -LiteralPath $ov) { $bgApps = Read-NameList $ov }
        $apps += Read-NameList (Join-Path $b.FullName 'applied_apps.txt')
    }
    [pscustomobject]@{ Count = $bks.Count; Latest = $bks[-1].Name; Flags = $flags
                       Apps = @($apps | Where-Object { $AppIgnore -notcontains $_ } | Sort-Object -Unique)
                       DefaultUser = $def; OneDriveSkipped = $skippedOd; BgApps = $bgApps; Startup = @($su.Values) }
}
function Write-Report([string]$kind, [string]$title, [string[]]$extra) {
    $file = Join-Path $script:ReportDir "${kind}_$($script:Stamp).txt"
    $head = @("$AppName (Best SFF Optimizer) - $Credit (MIT License)", "$AppName 이 PC $title ($(Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))") + @($extra | Where-Object { $_ }) +
            @("주의 $($script:Warn.Count)건") + @($script:Warn | ForEach-Object { "  - $_" })
    Write-TextFile $file (((@($head) + @($script:Out)) -join "`r`n") + "`r`n")
    return $file
}
# 미리보기 중 고르는 창에서 취소: 여기서 멈추고 짧은 보고서만 남김 (아무것도 저장하지 않음)
function Stop-PreviewCancel([string]$step) {
    Say ''
    Say "  '$step' 창에서 취소해서 미리보기를 멈췄어요. 이번에 고른 것은 하나도 저장하지 않았어요 (전에 고른 값 그대로)."
    $file = Write-Report 'preview' '미리보기 (취소함)'
    Write-Host "`n미리보기를 취소했어요. 아무것도 바꾸거나 저장하지 않았어요. 보고서: $file" -ForegroundColor Yellow
}
function Show-WarnSummary {
    if ($script:Warn.Count) {
        Write-Host "`n주의 $($script:Warn.Count)건:" -ForegroundColor Yellow
        $script:Warn | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
    }
}

function Show-SystemInfo {
    Head '이 PC'
    Say "  Windows: $($Win.ProductName) / $(if ($Win.DisplayVersion) { $Win.DisplayVersion } else { '버전 이름 없음' }) / 빌드 $($Win.Build).$($Win.UBR) / EditionID $($Win.Edition)"
    $me = Get-CurrentUserName
    $ex = Get-ExplorerUser
    Say "  실행 계정: $me / 로그인한 계정(탐색기): $(if ($ex) { $ex } else { '확인 못 함' })"
    $script:UserMismatch = [bool]($ex -and $ex -ne $me)
    if ($script:UserMismatch) { Warn "실행 계정과 로그인한 계정이 달라요. 사용자 설정(HKCU)이 '$me' 에 적용돼요. 로그인한 계정으로 관리자 실행하세요." }
    if (Test-PendingReboot) {
        if ($script:Mode -eq 'Check') { Warn '다시 시작을 기다리는 작업(업데이트·구성요소 제거 등)이 있어요. 다시 시작한 뒤 점검하면 정확해요.' }
        else { Warn '설치를 마치려고 다시 시작을 기다리는 업데이트가 있어요. 적용 전에 한 번 다시 시작하는 걸 권해요.' }
    }
    try {
        $bl = Get-BitLockerVolume -MountPoint $env:SystemDrive -ErrorAction Stop
        Say "  BitLocker ($env:SystemDrive): $($bl.VolumeStatus) / 보호 $($bl.ProtectionStatus)  (설정은 앞으로의 자동 암호화만 막고, 이미 암호화된 건 그대로)"
    } catch { Say '  BitLocker: 확인 못 함' }
    $rpText = '없음'
    try {
        $rp = @(Get-ComputerRestorePoint -ErrorAction Stop) | Select-Object -Last 1
        if ($rp) { $rpText = "$($rp.Description) ($(try { $rp.ConvertToDateTime($rp.CreationTime) } catch { $rp.CreationTime }))" }
    } catch { $rpText = '확인 못 함 (시스템 보호가 꺼져 있을 수 있음)' }
    Say "  마지막 복원 지점: $rpText"
    try {
        $rs = "$((Get-WindowsReservedStorageState -ErrorAction Stop).ReservedStorageState)"
        Say "  예약된 저장소: $rs$(if ($rs -ne 'Disabled' -and $script:Mode -ne 'Check') { '  (설정·정책을 적용하면 끔: 약 7GB 확보)' })"
    } catch { Say '  예약된 저장소: 확인 못 함' }
}

# ============================== 미리보기 · 점검 ==============================
# 미리보기: 지금 상태와 바뀔 내용 (지울 앱 고르기 포함). 점검: 적용한 것이 지금도 맞는지 (다른 것마다 [주의])
function Invoke-Report {
    $check   = ($script:Mode -eq 'Check')
    $history = Get-AppliedInfo
    $strict  = [bool]($check -and $history)
    Show-SystemInfo
    if ($check) {
        $flags = if ($strict) { $history.Flags } else { New-DefaultFlags }
        if ($strict) {
            Say "  적용 기록: $($history.Count)번 (마지막 $($history.Latest)). 그때 적용한 항목을 기준으로 점검해요."
            # 백그라운드 예외는 '지금 고른 것'이 아니라 '적용했던 것'과 비교해야 함 (안 그러면 미리보기에서 바꾸기만 해도 다르다고 나옴)
            if ($null -ne $history.BgApps) { Set-BgExtra $history.BgApps }
            else { foreach ($r in $script:Reg) { if ($r.Name -eq 'LetAppsRunInBackground_ForceAllowTheseApps') { $r.Skip = '예전 적용이라 예외 목록을 기록 안 함 (다시 적용하면 점검돼요)' } } }
        }
        else { Say '  적용 기록이 없어요 (아직 2_Apply 를 안 했거나 되돌렸음). 적용하면 바뀔 내용만 보여 줘요.' }
    } else {
        # 미리보기: 무엇을 적용할지 창에서 고름 (아무 PC 나 여기서 맞춤)
        # 창이 차례로 열림: 설정 → 백그라운드 예외(설정을 고른 경우) → 검색 색인 → Defender(체크한 경우) → 지울 앱(앱 삭제를 고른 경우) → 시작 프로그램.
        # 어느 창에서든 취소하면 미리보기 전체를 멈추고, 고른 값은 마지막 창까지 확인했을 때만 한꺼번에 저장 (중간에 취소하면 전에 고른 값 그대로)
        Head '무엇을 적용할지 고르기'
        $cur = Read-Options; if ($null -eq $cur) { $cur = New-DefaultFlags }
        Say '  고르는 창이 차례로 열려요. 어느 창에서든 취소하면 미리보기를 멈추고, 이번에 고른 것은 저장하지 않아요.'
        $picked = Show-SettingsPicker $cur
        if ($null -eq $picked) { Stop-PreviewCancel '무엇을 적용할까요'; return }
        $flags = $picked
        Say ("  적용할 항목: " + (@($flags.Keys | Where-Object { $flags[$_] -and $OptLabels.Contains($_) } | ForEach-Object { ($OptLabels[$_] -split ' \(')[0] }) -join ', '))   # .Split(' (') 는 5.1 에서 글자 하나씩 나눠 '앱'만 남음
        # 백그라운드 예외는 설정을 적용할 때만 고름
        $bgp = $null
        if ($flags.Settings) {
            $defBg = @(Get-BgDefaultFamilies)
            $pre = Read-BgSelection
            # 아직 안 골랐거나, v16 의 빈 창 때문에 빈 값이 저장돼 있으면 추천 기본값을 체크해 둠
            if ($null -eq $pre) { $pre = $defBg }
            if ($script:BgEmptyLegacy) { Say '  전에 저장된 백그라운드 예외가 비어 있어요 (예전 버전에서 고르는 창이 빈칸으로 뜬 문제). 추천 기본값을 체크해 둘게요.' }
            $cand = @(Get-BgCandidates -Detail)
            if ($script:BgReadError) {
                # 목록을 못 읽었으면 빈 창을 띄우지 않고, 고른 것도 덮어쓰지 않음
                Warn "설치된 앱 목록을 읽지 못해 백그라운드 예외 고르는 창을 건너뛰어요 ($($script:BgReadError)). 전에 고른 것(없으면 휴대폰과 연결만)을 그대로 써요."
            } elseif (-not $cand.Count) {
                Say '  백그라운드 예외로 고를 스토어 앱이 이 PC 에 없어요 (휴대폰과 연결은 항상 허용).'
            } else {
                Say "  백그라운드 허용 고르는 창이 열려요. 프로그램별로 묶여 있어요. (앱 $($cand.Count)개, 추천 $($defBg.Count)개)"
                $bgp = Show-BgPicker $cand $pre $defBg
                if ($null -eq $bgp) { Stop-PreviewCancel '백그라운드 예외 고르기'; return }
                Say "  백그라운드 예외: $(@($bgp).Count)개 고름"
            }
        }
        # 검색 색인은 따로 크게 물어봄 (다른 항목 사이에 있으면 놓치기 쉬워서)
        if (-not (Select-SearchOption $flags)) { Stop-PreviewCancel '검색 색인'; return }
        if (-not (Select-DefenderOption $flags)) { Stop-PreviewCancel 'Defender 예약 검사'; return }
        # 지울 앱 (전에 고른 것 + 지웠는데 다시 생긴 것을 미리 체크해 둠)
        $appPick = $null
        if ($flags.Apps) {
            $apps0 = @(Get-AppStatus)
            if ($apps0.Count) {
                Head '지울 앱 고르기'
                $present0 = @($apps0 | ForEach-Object Name)
                $back0 = @(@($(if ($history) { $history.Apps })) | Where-Object { $_ -and $present0 -contains $_ })
                $sel0 = Read-Selection   # 변수에 먼저 받음 (@(Read-Selection) 은 목록이 한 덩어리로 들어가 미리 체크가 안 됨)
                $pre = @(@($sel0) + $back0 | Where-Object { $_ } | Sort-Object -Unique)
                Say '  고르는 창이 열려요. 지울 앱만 체크하세요.'
                $appPick = Show-AppPicker $apps0 $pre
                if ($null -eq $appPick) { Stop-PreviewCancel '지울 앱 고르기'; return }
            }
        }
        # 시작 프로그램 (처음 체크 = 지금 상태, 전에 골라 둔 것이 있으면 그 값)
        $suPlan = $null
        if ($flags.Startup) {
            $su = @(Get-StartupItems)
            if ($su.Count) {
                Head '시작 프로그램 고르기'
                Say "  고르는 창이 열려요. 로그인할 때 켜 둘 것만 체크하세요. (지금 켜짐 $(@($su | Where-Object On).Count)개, 꺼짐 $(@($su | Where-Object { -not $_.On }).Count)개)"
                $pick = Show-StartupPicker $su (Get-StartupWant $su (Read-StartupSelection))
                if ($null -eq $pick) { Stop-PreviewCancel '시작 프로그램 고르기'; return }
                $suPlan = @(Get-StartupChanges $su $pick)
            } else { $suPlan = @() }
        }
        # 모든 창에서 확인을 눌렀을 때만 한꺼번에 저장
        Save-Options $flags
        if ($null -ne $bgp) { Save-BgSelection $bgp; Set-BgExtra $bgp }
        if ($null -ne $appPick) { Save-Selection @($appPick) }
        if ($null -ne $suPlan) { Save-StartupSelection $suPlan; Set-StartupPlan $suPlan }
        Say '  고른 것을 모두 저장했어요. 적용(메뉴 2)할 때 이대로 써요.'
    }

    # ---- 앱 ----
    if ($flags.Apps) {
        $apps    = @(Get-AppStatus)
        $present = @($apps | ForEach-Object Name)
        $removed = if ($history) { @($history.Apps) } else { @() }
        $back    = @($removed | Where-Object { $present -contains $_ })      # 지웠는데 다시 생긴 앱
        $sel     = Read-Selection
        if ($check) {
            Head '앱 (지금 남아 있는 것)'
            if ($strict) {
                Say "  지금까지 지운 앱 $($removed.Count)개 중 다시 생긴 것: $($back.Count)개"
                foreach ($n in $back) { Warn "지웠던 앱이 다시 있어요: $(Get-AppLabel $n) ($n). 메뉴 2(적용)를 실행하면 다시 지울지 물어봐요." }
            }
        } else {
            Head '앱 (지울 앱 목록)'   # 고르는 창은 위 '지울 앱 고르기'에서 이미 띄움
        }
        if (-not $apps.Count) { Say '  목록에 있는 앱이 이 PC 에 없어요.' }
        foreach ($a in $apps) {
            $mark = if ($back -contains $a.Name) { '다시 생김' } elseif (@($sel) -contains $a.Name) { '지움' } else { '남김' }
            Say ("  [{0}] {1}  ({2}, {3}, {4})" -f $mark, $a.Label, $a.Name, (Get-AppStateText $a), $a.Version)
        }
        $toRemove = @(@($sel) | Where-Object { $present -contains $_ })
        $pending  = @($toRemove | Where-Object { $back -notcontains $_ })     # 점검: 다시 생긴 앱은 위에서 이미 알림
        if (-not $check) { Say "  → 지울 앱 $($toRemove.Count)개 (선택 저장: $($script:SelFile))" }
        elseif ($pending.Count) { Say "  고른 채로 아직 안 지운 앱 $($pending.Count)개: $($pending -join ', ') (메뉴 2(적용)로 지움)" }
    }

    # ---- 시스템 구성요소 ----
    if ($flags.SystemComponents) {
        Head '시스템 구성요소'
        Write-Host '   (시스템 구성요소를 확인하는 중이에요. 길면 1~2분 걸릴 수 있어요...)' -ForegroundColor DarkGray
        foreach ($c in Get-CapStatus) {
            $here = ($c.State -eq 'Installed')
            if ($strict -and $here) { Warn "다시 설치돼 있어요: $($c.Label) (메뉴 2(적용)로 다시 지울 수 있어요)" }
            $act = if ($here) { if ($strict) { '다시 있음' } else { '지움' } } elseif ($c.State -eq '확인 못 함') { '확인 못 함' } else { '없음' }
            Say ("  [{0}] {1}  ({2}, 지금: {3})" -f $act, $c.Label, $c.Pattern.TrimEnd('*'), $c.State)
        }
        $rc = Get-RecallState
        $on = ($rc -eq 'Enabled')
        if ($strict -and $on) { Warn 'Recall 기능이 다시 켜져 있어요 (메뉴 2(적용)로 다시 지울 수 있어요)' }
        Say ("  [{0}] Recall 기능  (지금: {1})" -f $(if ($on) { if ($strict) { '다시 있음' } else { '지움' } } else { '없음/꺼짐' }), $rc)
    }

    # ---- 레지스트리 ----
    $items = @(Get-ActiveRegItems $flags | Where-Object { $_.Kind -ne 'Track' -and $_.Cat -ne 'Startup' })   # 시작 프로그램은 아래에서 따로
    if ($items.Count) {
        Head $(if ($strict) { '레지스트리 (맞게 돼 있는지)' } else { '레지스트리 (지금 → 바뀔 값)' })
        $diffN = 0; $sameN = 0
        foreach ($g in ($items | Group-Object Cat | Sort-Object { $CatOrder.IndexOf($_.Name) })) {
            Say "  -- $($CatLabels[$g.Name])"
            foreach ($r in $g.Group) {
                $root = Get-RootName $r.Hive
                $s    = Get-ItemState $r $root
                $who  = if ($r.Hive -eq 'HKCU') { if ($r.CurOnly) { ' [지금 사용자]' } else { ' [지금 사용자 + 새 사용자]' } } else { '' }
                if ($s.Ok) {
                    $sameN++
                    if ($strict) { Say ("    OK {0}: {1}{2}" -f $r.Desc, $s.Now, $who) } else { Say ("       {0}: {1} (이미 됨){2}" -f $r.Desc, $s.Now, $who) }
                } else {
                    $diffN++
                    $hint = if ($r.Cat -eq 'Search') { ' 검색 색인을 쓰려고 일부러 켠 거면 메뉴 5(일부 옵션만 복구) → 2. 검색 색인 다시 켜기를 하면 점검에서 빠져요.' } else { '' }
                    if ($strict) { Warn ("다름: $($r.Desc) - 지금 $($s.Now), 맞는 값 $($s.Target) ($root\$($r.Key)$(if ($r.Name) { " $($r.Name)" }))$hint") }
                    else { Say ("    *  {0}: {1} → {2}{3}" -f $r.Desc, $s.Now, $s.Target, $who) }
                }
            }
        }
        if ($strict) { Say "  (맞음 $sameN 개, 다름 $diffN 개)" } else { Say "  (* = 바뀌는 항목 $diffN 개, 이미 같은 값 $sameN 개)" }
        foreach ($r in Get-SkippedRegItems $flags) { Say "  건너뜀: $($r.Desc) - $($r.Skip)" }
        if (-not $strict) { Say '  빼는 빌드 항목: 시작 메뉴 고정 앱 비우기(지금 고정해 둔 앱이 사라져서), 사용자 Run 키 통째 삭제(OneDrive 항목만 지움)' }
        if ($strict -and $history.DefaultUser) { Test-DefaultUserItems $items }
    }

    # ---- 그 밖의 설정 ----
    $plan = @(Get-ServicePlan $flags)
    $searchOff = (-not $flags.DisableSearch) -and [bool](Get-Service -Name WSearch -ErrorAction SilentlyContinue) -and ((Get-ScTypeFromRegistry 'WSearch') -eq 'disabled')
    if ($flags.Settings -or $plan.Count -or $searchOff) {
        Head '그 밖의 설정'
        if ($searchOff) {
            if ($strict -or $check) { Say "  검색 색인(WSearch): 꺼져 있음. 다시 켜려면 메뉴 5(일부 옵션만 복구) → 2. 검색 색인 다시 켜기" }
            else { Say "  검색 색인(WSearch): 지금 꺼져 있음 → '켜 두기'를 골라서 적용하면 다시 켜요 (원래 시작 유형으로)" }
        }
        foreach ($p in $plan) {
            $svc = Get-Service -Name $p.Name -ErrorAction SilentlyContinue
            if (-not $svc) { Say "  서비스 $($p.Name): 이 PC 에 없음"; continue }
            Say ("  서비스 {0}: {1} / {2}{3}" -f $p.Name, $svc.StartType, $svc.Status, $(if ($strict) { '' } else { "  → $($p.Want)$(if ($p.Stop) { ', 멈춤' })" }))
            if ($strict) {
                if ("$($svc.StartType)" -ne $p.Want) {
                    # 레지스트리 값부터 다르면 위 레지스트리 항목에서 이미 알렸으니, 여기선 '레지스트리는 맞는데 아직 반영 안 됨'만 알림
                    if ((Get-ScTypeFromRegistry $p.Name) -eq $p.Sc) { Warn "서비스 $($p.Name) 시작 유형이 지금 $($svc.StartType) 이에요 (맞는 값 $($p.Want)). 레지스트리 값은 맞아서 다시 시작하면 맞춰져요." }
                }
                if ($p.Stop -and "$($svc.Status)" -eq 'Running' -and "$($svc.StartType)" -eq $p.Want) { Warn "서비스 $($p.Name) 가 실행 중이에요 (사용 안 함으로 해 뒀는데 켜져 있음). 다시 시작하거나 메뉴 2(적용)를 다시 실행하세요." }
            }
        }
    }
    if ($flags.Settings) {
        $t = Read-TerminalSettings
        if ($t.Error) { Warn "터미널 설정 파일을 읽지 못했어요 (적용 때도 건드리지 않음): $($t.Error)" }
        elseif ($t.Exists) {
            $el = [bool]$t.Json.profiles.defaults.elevate
            Say ("  터미널: 기본 프로필 {0} / 모든 탭 관리자 권한 {1}{2}" -f (Get-ProfileName $t.Json.defaultProfile), (YesNo $el), $(if ($strict) { '' } else { '  → 기본 프로필은 그대로, 모든 탭 관리자 권한 (설정 파일은 백업)' }))
            if ($strict -and -not $el) { Warn '터미널 모든 탭 관리자 권한이 꺼져 있어요. 메뉴 2(적용)를 다시 실행하세요.' }
        } elseif (Test-TerminalInstalled) {
            Say "  터미널 설정 파일 없음$(if (-not $strict) { ' → 새로 만듦 (PowerShell 7 이 있으면 기본 프로필로, 모든 탭 관리자 권한)' })"
            if ($strict) { Warn '터미널 설정 파일이 없어요 (적용 뒤 지워졌거나 터미널을 다시 설치함). 메뉴 2(적용)를 다시 실행하세요.' }
        } else { Say '  터미널 앱 없음 (건너뜀)' }
        Say "  PowerShell 7: $(if (Test-Pwsh) { '있음' } else { '없음' })"
        $links = @(Get-ShellLinks)
        $notRun = @($links | Where-Object { -not (Test-LnkRunAsSafe $_.FullName) })
        Say ("  시작 메뉴 명령 프롬프트·PowerShell 바로가기 {0}개 (관리자 실행: {1}개){2}" -f $links.Count, ($links.Count - $notRun.Count), $(if ($strict) { '' } else { ' → 모두 관리자 권한으로 실행' }))
        if ($strict -and $notRun.Count) { Warn "관리자 실행이 아닌 바로가기 $($notRun.Count)개: $(($notRun | ForEach-Object Name) -join ', ') (적용 뒤 새로 생긴 것이면 메뉴 2(적용)를 다시 실행하세요)" }
        if ($strict) {
            try {
                $rs = "$((Get-WindowsReservedStorageState -ErrorAction Stop).ReservedStorageState)"
                if ($rs -ne 'Disabled') { Warn "예약된 저장소가 켜져 있어요 ($rs). 메뉴 2(적용)를 다시 실행하면 꺼요 (업데이트가 진행 중이면 안 꺼져요)." }
            } catch {}
        }
        # 백그라운드 허용·금지 (알기 쉬운 이름으로)
        $bgc = @(Get-BgCandidates -Detail)
        if ($script:BgReadError) { Say "  (설치된 앱 목록을 읽지 못해 백그라운드 막힘 목록은 건너뜀: $($script:BgReadError))" }
        $blocked = @($bgc | Where-Object { $script:BgAllowed -notcontains $_.Family })
        $allowedTxt = @($script:BgAllowed | ForEach-Object { $f0 = $_; $m = $bgc | Where-Object Family -eq $f0 | Select-Object -First 1; if ($m) { $m.Label } elseif ($BgAlways -contains $f0) { '휴대폰과 연결' } else { $f0 -replace '_[^_]+$', '' } } | Sort-Object -Unique)
        Say "  백그라운드 켜 둠 (허용) $($allowedTxt.Count)개: $($allowedTxt -join ', ')"
        Say "  백그라운드 막힘 (스토어 앱) $($blocked.Count)개: $(if ($blocked.Count) { ($blocked | ForEach-Object Label | Sort-Object -Unique) -join ', ' } else { '없음' })"
        $recOff = @($blocked | Where-Object Rec)
        if ($recOff.Count) { Say "  ※ 막혀 있는 추천(★) 항목 - 동기화·알림·공유가 안 될 수 있어요: $(($recOff | ForEach-Object { "$($_.Label) [$($_.Kind)]" }) -join ', ')$(if ($strict) { ' (필요하면 메뉴 5(일부 옵션만 복구) 에서 다시 켜세요)' })" }
        # 예전 버전(빈 창)으로 적용해서 예외가 휴대폰과 연결만 들어간 경우 알림 (일부러 비운 경우(#NONE)는 빼고)
        if ($strict -and $null -ne $history.BgApps -and -not @($history.BgApps).Count -and $null -eq (Read-BgSelection)) {
            Warn ("백그라운드 예외가 휴대폰과 연결만 적용돼 있어요 (예전 버전에서 고르는 창이 빈칸으로 뜬 문제). " +
                  "그래서 스토어에서 설치한 앱이 모두 백그라운드에서 막혀 있어요" +
                  $(if ($recOff.Count) { " - 특히 $(($recOff | ForEach-Object Label) -join ', ')" } else { '' }) +
                  ". 메뉴 5(일부 옵션만 복구) → 1. 백그라운드 앱 다시 켜기에서 골라 켜면 바로 고쳐져요.")
        }
    }

    # ---- 시작 프로그램 ----
    if ($flags.Startup) {
        Head '시작 프로그램'
        if ($strict) {
            # 점검: BeSffy 로 바꾼 것이 지금도 그대로인지 (작업 관리자에서 다시 바꾸는 건 사용자 마음이라 주의가 아니라 안내만)
            $hp = @($history.Startup)
            if (-not $hp.Count) { Say '  BeSffy 로 바꾼 시작 프로그램이 없어요.' }
            else {
                $moved = @($hp | Where-Object { $n = Get-StartupNow $_.Id; $null -ne $n -and $n -ne $_.Want })
                Say "  BeSffy 로 바꾼 시작 프로그램 $($hp.Count)개 (끔 $(@($hp | Where-Object { -not $_.Want }).Count)개, 켬 $(@($hp | Where-Object Want).Count)개) 중 지금도 그대로 $($hp.Count - $moved.Count)개"
                if ($moved.Count) { Say "  그 뒤 다시 바뀐 것 (작업 관리자에서 바꿨거나 프로그램이 직접 바꿈): $(($moved | ForEach-Object Label) -join ', '). 다시 맞추려면 메뉴 1(미리보기)에서 고른 뒤 메뉴 2(적용)" }
            }
        } else {
            $plan = @($script:StartupPlan)
            $off = @($plan | Where-Object { -not $_.Want }); $on = @($plan | Where-Object Want)
            if (-not $plan.Count) { Say "  바꿀 것 없음 (지금 상태 그대로)$(if ($check -or $null -eq (Read-StartupSelection)) { '. 미리보기에서 고르면 그대로 적용해요' })" }
            if ($off.Count) { Say "  로그인할 때 안 켜지게 (끔) $($off.Count)개: $(($off | ForEach-Object Label) -join ', ')" }
            if ($on.Count)  { Say "  다시 켬 $($on.Count)개: $(($on | ForEach-Object Label) -join ', ')" }
        }
    }

    # ---- Defender 예약 검사 ----
    if ($flags.DefenderScan) {
        Head 'Defender 예약 검사'
        $dp = Get-DefenderScanPref
        if ($null -eq $dp) { Say "  Defender 설정을 읽지 못해 건너뛰어요 (다른 백신을 쓰거나 Defender 가 꺼져 있음: $($script:DefenderErr))" }
        elseif ($strict) {
            if (Test-DefenderWanted $dp) { Say "  OK $(Format-DefenderPref $dp)" }
            else { Warn "Defender 예약 검사 제한이 바뀌어 있어요 (지금 $(Format-DefenderPref $dp)). 메뉴 2(적용)를 다시 실행하세요." }
        } else {
            $a = Get-DefenderAdvice $dp
            foreach ($l in @($a.Scan, $a.Now, "→ $($a.Hint)")) { if ($l) { Say "  $l" } }
            Say '  바꿀 값: CPU 평균 20% / PC 가 쉴 때도 제한 예 / 낮은 우선순위 예 (실시간 보호는 그대로, 예약 검사가 조금 더 오래 걸려요)'
        }
    }

    # ---- 업데이트 잠금 ----
    if ($flags.UpdateLock) {
        Head '업데이트 잠금'
        $umode = "$((Get-RegValue $HKLM $FlagKey 'UpdateMode').Value)"
        $exp   = "$((Get-RegValue $HKLM 'SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' 'PauseUpdatesExpiryTime').Value)"
        Say "  일시정지 만료: $(if ($exp) { $exp } else { '없음' })$(if (-not $strict) { "  → $PauseEnd" })"
        if ($strict) {
            if ($umode -eq 'On') {
                $since = "$((Get-RegValue $HKLM $FlagKey 'UpdateModeSince').Value)"
                Say "  지금 '업데이트 켜기' 상태예요 (켠 시각 $since). 다 끝나면 바탕화면 'Windows 업데이트 끄기'를 실행하세요. 깜빡해도 3일 뒤 예약 작업이 다시 잠가요."
            } elseif ($exp -ne $PauseEnd) {
                Warn "업데이트 일시정지가 풀려 있어요 (만료: $(if ($exp) { $exp } else { '없음' })). 바탕화면 'Windows 업데이트 끄기'를 실행하거나 메뉴 2(적용)를 다시 실행하세요."
            }
        }
        Say "  버전 고정: $(if ($script:DisplayVersion) { $script:DisplayVersion } else { '건너뜀 (버전 이름을 못 읽음)' })"
        $task = Get-ScheduledTask -TaskPath $TaskPath -TaskName $TaskName -ErrorAction SilentlyContinue
        Say ("  예약 작업 {0}{1} (부팅 때·매일 다시 잠금): {2}{3}" -f $TaskPath, $TaskName, $(if ($task) { "있음 ($($task.State))" } else { '없음' }), $(if ($strict) { '' } elseif ($task) { ' → 다시 등록' } else { ' → 새로 만듦' }))
        if ($strict -and -not $task) { Warn '예약 작업 WU-RePause 가 없어요. 메뉴 2(적용)를 다시 실행하세요.' }
        elseif ($strict -and "$($task.State)" -eq 'Disabled') { Warn "예약 작업 WU-RePause 가 꺼져 있어요 (작업 스케줄러 → $AppName 에서 사용)." }
        $haveLinks = @($WuLinks.Keys | Where-Object { Test-Path -LiteralPath (Join-Path $script:PublicDesk $_) })
        $haveTools = @($ToolFiles | Where-Object { Test-Path -LiteralPath (Join-Path $script:ToolsDst $_) })
        Say "  바탕화면(모든 사용자) 켜기/끄기 바로가기: $($haveLinks.Count)/$($WuLinks.Count)개 / $AppName 도구($($script:ToolsDst)): $($haveTools.Count)/$($ToolFiles.Count)개"
        if ($strict -and $haveLinks.Count -lt $WuLinks.Count) { Warn "바탕화면 업데이트 켜기/끄기 바로가기가 $($WuLinks.Count - $haveLinks.Count)개 없어요. 메뉴 2(적용)를 다시 실행하세요." }
        if ($strict -and $haveTools.Count -lt $ToolFiles.Count) { Warn "$AppName 도구 스크립트가 $($ToolFiles.Count - $haveTools.Count)개 없어요. 적용을 다시 하세요." }
    }

    # ---- OneDrive ----
    if ($flags.OneDrive -or ($strict -and $history.OneDriveSkipped)) {
        Head 'OneDrive'
        $od = Get-OneDriveInfo -NoScan:$strict
        if ($strict -and $history.OneDriveSkipped -and -not $flags.OneDrive) { Say '  적용 때 건너뜀 (OneDrive 안으로 옮겨진 폴더가 있었음)' }
        if (-not $od.Installed) { Say "  설치돼 있지 않음$(if (-not $strict) { ' (동기화 막기 정책만 적용)' })" }
        else {
            foreach ($u in $od.Uninstall) { Say "  설치됨 ($($u.Scope), $($u.Version)) / 실행 중: $(YesNo $od.Running)" }
            Say "  OneDrive 폴더: $($od.Folder) (지우지 않음, 파일은 그대로 남음)"
            if ($strict -and $flags.OneDrive) { Warn 'OneDrive 가 다시 설치돼 있어요 (동기화 막기 정책 때문에 동작은 안 해요). 메뉴 2(적용)로 다시 지울 수 있어요.' }
            if (-not $strict) {
                if ($od.Moved.Count) { Warn ("'PC 폴더 백업'으로 OneDrive 안으로 옮겨진 폴더: " + ($od.Moved -join ', ') + '. 적용 때 OneDrive 는 통째로 건너뛰어요. OneDrive 설정 → 동기화 및 백업 → 백업 관리에서 먼저 끄세요.') }
                Say "  클라우드에만 있는 파일: $($od.CloudOnly)개 (파일 $($od.Scanned)개 확인$(if ($od.Partial) { ', 시간 제한으로 일부만' }))"
                if ($od.CloudOnly) { Warn '클라우드에만 있는 파일은 OneDrive 를 지우면 PC 에서 열 수 없어요 (클라우드에는 남음). 필요한 건 먼저 "이 장치에 항상 유지"로 받아 두세요.' }
            }
        }
    }

    if ($check) {
        $file = Write-Report 'check' '점검' @($(if ($strict) { "적용 기록 $($history.Count)번 기준 (마지막 $($history.Latest))" } else { '적용 기록 없음' }))
        Show-WarnSummary
        $msg = if (-not $strict) { '적용 기록이 없어 점검할 게 없어요.' } elseif ($script:Warn.Count) { "점검 끝. 주의 $($script:Warn.Count)건 (위 목록)." } else { '점검 끝. 모두 맞게 돼 있어요.' }
        Write-Host "`n$msg 아무것도 바꾸지 않았어요. 보고서: $file" -ForegroundColor Green
    } else {
        $file = Write-Report 'preview' '적용 미리보기'
        Show-WarnSummary
        Write-Host "`n미리보기 끝. 아무것도 바꾸지 않았어요. 보고서: $file" -ForegroundColor Green
    }
    Write-Host '위 내용과 보고서 파일을 확인해 보세요.'
}
# 점검: 새 사용자 기본값도 맞는지 (적용 때 새 사용자 쪽도 했을 때만)
function Test-DefaultUserItems($items) {
    $def = @($items | Where-Object { $_.Hive -eq 'HKCU' -and -not $_.CurOnly })
    if (-not $def.Count) { return }
    if (-not (Mount-DefaultHive)) { return }
    try {
        $bad = 0
        foreach ($r in $def) {
            $s = Get-ItemState $r (Get-RootName 'HKCU' -Default)
            if (-not $s.Ok) { $bad++; Warn "새 사용자 기본값 다름: $($r.Desc) - 지금 $($s.Now), 맞는 값 $($s.Target)" }
        }
        Say "  새 사용자 기본값: $($def.Count)개 중 $($def.Count - $bad)개 맞음"
    } finally { Dismount-DefaultHive }
}

# ============================== 적용 ==============================
function New-RestorePoint {
    $srKey = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore'
    $had = Get-RegValue $HKLM $srKey 'SystemRestorePointCreationFrequency'
    try {
        # 하루 1개 제한을 잠깐 풀어서 바로 만들 수 있게
        Set-RegDirect $HKLM $srKey 'SystemRestorePointCreationFrequency' 'DWord' 0
        for ($try = 0; $try -lt 2; $try++) {
            try {
                Checkpoint-Computer -Description "BeSffy 적용 전 ($($script:Stamp))" -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
                $rp = @(Get-ComputerRestorePoint -ErrorAction SilentlyContinue | Where-Object { "$($_.Description)" -like "*$($script:Stamp)*" })
                if ($rp.Count) { $rp = $rp[-1]; Say "  복원 지점 만듦: $($rp.Description) ($(try { $rp.ConvertToDateTime($rp.CreationTime) } catch { $rp.CreationTime }))"; return $true }
                Say '  복원 지점을 만들었다고 했지만 목록에서 찾지 못했어요.'
            } catch { Say "  복원 지점 실패: $($_.Exception.Message)" }
            if ($try -eq 0) {
                if (Ask "  $env:SystemDrive 의 시스템 보호가 꺼져 있을 수 있어요. 시스템 보호를 켜고 다시 만들까요?") {
                    try { Enable-ComputerRestore -Drive "$env:SystemDrive\" -ErrorAction Stop } catch { Say "  시스템 보호 켜기 실패: $($_.Exception.Message)" }
                } else { break }
            }
        }
        return $false
    } finally {
        try {
            if ($had.Exists) { Set-RegDirect $HKLM $srKey 'SystemRestorePointCreationFrequency' $had.Kind $had.Value }
            else { Remove-RegValueDirect $HKLM $srKey 'SystemRestorePointCreationFrequency' }
        } catch {}
    }
}

# 단계 하나 실행: 오류가 나도 그 단계만 멈추고 다음 단계는 계속
function Invoke-Step([string]$title, [scriptblock]$body) {
    Head $title
    try { & $body }
    catch { Warn "'$title' 단계에서 오류가 나서 이 단계는 멈추고 다음 단계로 넘어가요: $($_.Exception.Message)" }
}

function Invoke-Apply {
    $script:ApplyDone = $false
    Show-SystemInfo
    if ($script:UserMismatch -and -not (Ask "`n실행 계정과 로그인한 계정이 달라요. 그래도 계속할까요?")) { Say '취소했어요. 아무것도 바꾸지 않았어요.'; return }
    # 이번 적용에서 실제로 할 것: 미리보기에서 창으로 고른 값(selected_options.txt). 없으면 지금 고르는 창을 엶
    # 고르는 창 어디서든 취소하면 적용 전체를 멈춤 (고른 값도 저장하지 않음)
    $flags = Read-Options
    $saveFlags = $false
    if ($null -eq $flags) {
        Say '  적용할 항목을 아직 안 골랐어요. 고르는 창을 열어요. (어느 창에서든 취소하면 적용을 멈춰요)'
        $flags = Show-SettingsPicker (New-DefaultFlags)
        if ($null -eq $flags) { Say '취소했어요. 아무것도 바꾸지 않았어요.'; return }
        if (-not (Select-SearchOption $flags)) { Say '취소했어요. 아무것도 바꾸지 않았어요.'; return }
        if (-not (Select-DefenderOption $flags)) { Say '취소했어요. 아무것도 바꾸지 않았어요.'; return }
        $saveFlags = $true
    }

    # ---- 지울 앱 ----
    $sel = @()
    if ($flags.Apps) {
        $apps    = @(Get-AppStatus)
        $present = @($apps | ForEach-Object Name)
        $chosen  = Read-Selection
        if ($null -eq $chosen -and $apps.Count) {
            Say '  지울 앱을 아직 안 골랐어요. 고르는 창을 열어요.'
            $chosen = Show-AppPicker $apps @()
            if ($null -eq $chosen) { Say '취소했어요. 아무것도 바꾸지 않았어요.'; return }
            Save-Selection $chosen
        }
        $sel  = @(@($chosen) | Where-Object { $_ -and $present -contains $_ } | Sort-Object -Unique)
        $gone = @(@($chosen) | Where-Object { $_ -and $present -notcontains $_ })
        if ($gone.Count) { Say "  고른 앱 중 이미 없는 것 $($gone.Count)개는 건너뜀: $($gone -join ', ')" }
        $history = Get-AppliedInfo
        $back = @(if ($history) { $history.Apps | Where-Object { $present -contains $_ -and $sel -notcontains $_ } })
        if ($back.Count -and (Ask ("  전에 지웠던 앱이 다시 생겼어요: " + (($back | ForEach-Object { Get-AppLabel $_ }) -join ', ') + '. 이것도 다시 지울까요?'))) {
            $sel = @($sel + $back)
        }
    }
    # ---- 시작 프로그램: 아직 안 골랐으면 고르는 창 ----
    if ($flags.Startup -and $null -eq (Read-StartupSelection)) {
        $su = @(Get-StartupItems); $suPlan = @()
        if ($su.Count) {
            Say '  시작 프로그램을 아직 안 골랐어요. 고르는 창을 열어요.'
            $pick = Show-StartupPicker $su (Get-StartupWant $su $null)
            if ($null -eq $pick) { Say '취소했어요. 아무것도 바꾸지 않았어요.'; return }
            $suPlan = @(Get-StartupChanges $su $pick)
        }
        Save-StartupSelection $suPlan; Set-StartupPlan $suPlan
    }
    if ($saveFlags) { Save-Options $flags }   # 창을 모두 고른 뒤에 저장 (아래에서 이번 적용용으로 Apps 를 끌 수 있어서 그 전에)
    if (-not $sel.Count) { $flags.Apps = $false }
    # Defender 를 못 쓰는 PC (다른 백신 등) 면 건너뜀
    $defNow = $null
    if ($flags.DefenderScan) {
        $defNow = Get-DefenderScanPref
        if ($null -eq $defNow) { Say "  Defender 설정을 읽지 못해 'Defender 예약 검사 가볍게'는 건너뛰어요 ($($script:DefenderErr))"; $flags.DefenderScan = $false }
    }

    # ---- OneDrive ----
    # 'PC 폴더 백업'으로 옮겨진 폴더가 있으면 통째로 건너뜀 (동기화 막기 정책도 안 씀:
    # 바탕 화면·문서가 OneDrive 안에 있는 채로 동기화가 멈추면 클라우드에만 있는 파일을 못 열게 됨)
    $od = $null; $odSkipped = $false
    if ($flags.OneDrive) {
        $od = Get-OneDriveInfo
        if ($od.Installed -and $od.Moved.Count) {
            Warn ("OneDrive 안으로 옮겨진 폴더가 있어 OneDrive 는 건너뛰어요: " + ($od.Moved -join ', ') + '. OneDrive 설정 → 동기화 및 백업 → 백업 관리에서 먼저 끄세요.')
            $flags.OneDrive = $false; $odSkipped = $true
        } elseif ($od.Installed -and $od.CloudOnly) {
            if (-not (Ask "  OneDrive 에 클라우드에만 있는 파일이 $($od.CloudOnly)개 있어요. 제거하면 PC 에서 열 수 없게 돼요 (클라우드에는 남음). 그래도 제거할까요?")) {
                $flags.OneDrive = $false; $odSkipped = $true; Say '  OneDrive 는 그대로 둬요.'
            }
        }
    }

    Head '적용할 내용'
    Say "  앱 삭제: $(if ($sel.Count) { "$($sel.Count)개 ($(($sel | ForEach-Object { Get-AppLabel $_ }) -join ', '))" } else { '없음' })"
    $wsOn = [bool](Get-Service -Name WSearch -ErrorAction SilentlyContinue)
    $searchOn = (-not $flags.DisableSearch) -and $wsOn -and ((Get-ScTypeFromRegistry 'WSearch') -eq 'disabled')
    $searchTxt = if ($flags.DisableSearch) { '끄기' } elseif ($searchOn) { '켜 두기 (지금 꺼져 있어서 다시 켬)' } else { '켜 두기' }
    Say ("  시스템 구성요소 삭제: {0} / 설정·정책: {1} / 업데이트 잠금: {2} / OneDrive 제거: {3} / 다크 모드: {4}" -f
        (YesNo $flags.SystemComponents), (YesNo $flags.Settings), (YesNo $flags.UpdateLock), (YesNo $flags.OneDrive), (YesNo $flags.DarkMode))
    if ($wsOn) { Say "  검색 색인: $searchTxt" }
    $suAct = @(Get-ActiveRegItems $flags | Where-Object Cat -eq 'Startup')
    if ($flags.Startup) { Say "  시작 프로그램: $(if ($suAct.Count) { "끔 $(@($script:StartupPlan | Where-Object { -not $_.Want }).Count)개 / 켬 $(@($script:StartupPlan | Where-Object Want).Count)개" } else { '바꿀 것 없음' })" }
    Say "  [베타기능] Defender 예약 검사 가볍게: $(YesNo $flags.DefenderScan)"
    foreach ($r in Get-SkippedRegItems $flags) { Say "  건너뜀: $($r.Desc) - $($r.Skip)" }
    if (-not (Ask "`n위 내용으로 적용할까요?")) { Say '취소했어요. 아무것도 바꾸지 않았어요.'; return }

    $S = @{ Bk = (Join-Path $script:BackupRoot $script:Stamp); Flags = $flags; Sel = $sel; Od = $od; OdSkipped = $odSkipped; DefOk = $false; Defender = $defNow }
    New-Item -ItemType Directory -Force -Path $S.Bk | Out-Null

    Head '1. 복원 지점'
    if (-not (New-RestorePoint)) {
        if (-not (Ask '  복원 지점 없이 계속할까요? (레지스트리 백업은 따로 만들어요)')) {
            Remove-Item -LiteralPath $S.Bk -Recurse -Force -ErrorAction SilentlyContinue
            Say '취소했어요. 아무것도 바꾸지 않았어요.'; return
        }
    }

    $items      = @(Get-ActiveRegItems $flags)               # 되돌리기 기록용 (Track 포함)
    $S.Active   = @($items | Where-Object Kind -ne 'Track')
    $S.DefItems = @($S.Active | Where-Object { $_.Hive -eq 'HKCU' -and -not $_.CurOnly })

    Head '2. 백업 (되돌리기용)'
    try { Backup-BeforeApply $S $items }
    catch {
        # 백업 없이 바꾸면 되돌릴 수 없으므로 여기서 멈춤 (state.json 이 없으면 되돌리기 대상도 아님)
        Warn "백업을 만들지 못해 적용을 멈췄어요 (아무것도 바꾸지 않음): $($_.Exception.Message)"
        Remove-Item -LiteralPath (Join-Path $S.Bk 'state.json') -Force -ErrorAction SilentlyContinue
        $file = Write-Report 'apply' '적용 결과 (백업 실패로 멈춤)' @("백업: $($S.Bk)")
        Write-Host "`n결과 보고서: $file" -ForegroundColor Green
        return
    }

    Invoke-Step '3. 레지스트리' { Set-RegistryItems $S }
    if (@(Get-ServicePlan $flags).Count) { Invoke-Step '4. 서비스' { Set-Services $S } }   # @(): 5.1 의 pscustomobject 하나에는 .Count 가 없음
    if (-not $flags.DisableSearch -and $wsOn) {
        # '켜 두기': 꺼져 있으면 원래대로 켜고, 예전에 끄기로 적용했던 기록이 있으면 '켜 둠'으로 남김 (점검이 꺼져 있어야 한다고 하지 않게)
        if ($searchOn) { Invoke-Step '4-2. 검색 색인 다시 켜기' { [void](Enable-SearchIndex) } }
        $h = Get-AppliedInfo
        if ($searchOn -or ($h -and $h.Flags.DisableSearch)) { Set-SearchKept -WasOff:$searchOn }
    }
    if ($flags.Settings)   { Invoke-Step '5. 터미널 · 바로가기 · 예약된 저장소' { Set-ShellSettings $S } }
    if ($flags.DefenderScan) { Invoke-Step '5-2. Defender 예약 검사' { Set-DefenderScan } }
    if ($flags.UpdateLock) { Invoke-Step '6. 업데이트 잠금' { Set-UpdateLock } }
    if ($flags.OneDrive)   { Invoke-Step '7. OneDrive' { Remove-OneDrive $S.Od } }
    if ($flags.Apps)       { Invoke-Step '8. 앱 삭제' { Remove-Apps $S } }
    if ($flags.SystemComponents) { Invoke-Step '9. 시스템 구성요소' { Remove-Components } }

    Head '끝'
    Say '  되돌리기: 메뉴 4(되돌리기) (레지스트리·서비스·업데이트 잠금·터미널·바로가기·예약된 저장소). 지운 앱은 스토어, 구성요소는 설정 → 선택적 기능, 전체는 복원 지점으로'
    Say '  점검: 다시 시작한 뒤 메뉴 3(점검)'
    Say '  백그라운드가 막혀서 안 되는 앱(클라우드 동기화·파일 공유·메신저 등)이 있거나, 검색 색인·꺼 둔 시작 프로그램을 다시 켜려면: 메뉴 5(일부 옵션만 복구)'
    Say '  다시 시작해야 서비스 묶기·빠른 시작·구성요소 제거·탐색기 설정이 모두 적용돼요.'
    $file = Write-Report 'apply' '적용 결과' @("백업: $($S.Bk)")
    Show-WarnSummary
    Write-Host "`n결과 보고서: $file" -ForegroundColor Green
    $script:ApplyDone = $true
}

function Backup-BeforeApply($S, $items) {
    $bk = $S.Bk
    # 값: 원래 값(또는 '없었음')을 되돌리기 .reg 로
    Write-RegFile (Join-Path $bk 'undo_values.reg') (Build-UndoLines $items)
    $newKeys = Get-NewKeys $items
    # 지울 키는 통째로 내보내 둠
    $i = 0
    foreach ($r in ($S.Active | Where-Object Kind -eq 'DeleteKey')) {
        $root = Get-RootName $r.Hive
        if (-not (Get-RegValue $root $r.Key '').KeyExists) { continue }
        $i++; $x = Invoke-Reg @('export', "$root\$($r.Key)", (Join-Path $bk ('deleted_key_{0:00}.reg' -f $i)), '/y')
        if ($x.Code -ne 0) { throw "지울 키를 내보내지 못했어요: $root\$($r.Key) ($($x.Text))" }
    }
    # 새 사용자 기본값
    $newDef = @()
    if ($S.DefItems.Count -and (Mount-DefaultHive)) {
        try {
            Write-RegFile (Join-Path $bk 'undo_values_defaultuser.reg') (Build-UndoLines $S.DefItems -Default)
            $newDef = Get-NewKeys $S.DefItems -Default
            $i = 0
            foreach ($r in ($S.DefItems | Where-Object Kind -eq 'DeleteKey')) {
                $root = Get-RootName $r.Hive -Default
                if (-not (Get-RegValue $root $r.Key '').KeyExists) { continue }
                $i++; $x = Invoke-Reg @('export', "$root\$($r.Key)", (Join-Path $bk ('deleted_key_default_{0:00}.reg' -f $i)), '/y')
                if ($x.Code -ne 0) { throw "지울 키를 내보내지 못했어요: $root\$($r.Key) ($($x.Text))" }
            }
            $S.DefOk = $true
        } finally { Dismount-DefaultHive }
    }
    # 서비스 상태 (되돌릴 때 원래 시작 유형으로 맞추고, 켜져 있던 건 다시 켬)
    $svcs = [ordered]@{}
    foreach ($p in Get-ServicePlan $S.Flags) {
        $svc = Get-Service -Name $p.Name -ErrorAction SilentlyContinue
        if ($svc) { $svcs[$p.Name] = [ordered]@{ Status = "$($svc.Status)"; StartType = "$($svc.StartType)"; Sc = (Get-ScTypeFromRegistry $p.Name) } }
    }
    $rs = ''; if ($S.Flags.Settings) { try { $rs = "$((Get-WindowsReservedStorageState -ErrorAction Stop).ReservedStorageState)" } catch {} }
    $state = [ordered]@{
        Version         = 9
        Stamp           = $script:Stamp
        User            = Get-CurrentUserName
        Applied         = $S.Flags
        BgApps          = @($script:BgExtra)
        OneDriveSkipped = $S.OdSkipped
        HadTask         = [bool](Get-ScheduledTask -TaskPath $TaskPath -TaskName $TaskName -ErrorAction SilentlyContinue)
        HadTools        = [bool](Test-Path -LiteralPath $script:ToolsDst)
        HadLinks        = @($WuLinks.Keys | Where-Object { Test-Path -LiteralPath (Join-Path $script:PublicDesk $_) })
        DefaultUser     = $S.DefOk
        Services        = $svcs
        ReservedStorage = $rs
        NewKeys         = @($newKeys)
        NewKeysDefault  = @($newDef)
        Startup         = @(if ($S.Flags.Startup) { $script:StartupPlan | Where-Object { $t = Get-StartupTarget $_.Id; $t -and $t.Exists } })
        Defender        = $S.Defender
    }
    Write-TextFile (Join-Path $bk 'state.json') ($state | ConvertTo-Json -Depth 6)
    Say "  백업 폴더: $bk"
    Say "  레지스트리 값 $(@($items).Count)개$(if ($S.DefOk) { ' + 새 사용자 기본값' }), 지울 키 내보내기, 새로 생길 키 $(@($newKeys).Count + @($newDef).Count)개 기록"
}

function Set-RegistryItems($S) {
    $f = Join-Path $S.Bk 'apply_values.reg'
    Write-RegFile $f (Build-ApplyLines $S.Active)
    $imp = Import-Reg $f
    $bad = Test-RegApplied $S.Active
    Say "  지금 사용자·시스템: $($S.Active.Count)개 중 $($S.Active.Count - $bad)개 적용 확인"
    if ($imp.Code -ne 0 -and -not $bad) { Say "  (가져오기 도구가 오류를 알렸지만 모든 값이 맞게 들어간 걸 확인했어요: $($imp.Text))" }
    if ($S.DefItems.Count) {
        if (-not $S.DefOk) { Say '  새 사용자 기본값: 백업 때 불러오지 못해 건너뜀' }
        elseif (Mount-DefaultHive) {
            try {
                $f = Join-Path $S.Bk 'apply_values_defaultuser.reg'
                Write-RegFile $f (Build-ApplyLines $S.DefItems -Default)
                $null = Import-Reg $f
                $bad = Test-RegApplied $S.DefItems -Default
                Say "  새 사용자 기본값: $($S.DefItems.Count)개 중 $($S.DefItems.Count - $bad)개 적용 확인"
            } finally { Dismount-DefaultHive }
        }
    }
}

function Set-Services($S) {
    foreach ($p in Get-ServicePlan $S.Flags) {
        if (-not (Get-Service -Name $p.Name -ErrorAction SilentlyContinue)) { Say "  $($p.Name): 이 PC 에 없음"; continue }
        $r = Set-ServiceStartType $p.Name $p.Sc
        $msg = if ($r.Code -eq 0) { "시작 유형 $($p.Want)" } else { "시작 유형은 레지스트리로 들어감 (다시 시작 후 $($p.Want))" }
        if ($p.Stop) {
            try { Stop-Service -Name $p.Name -Force -ErrorAction Stop; $msg += ', 멈춤' }
            catch { $msg += ", 멈추기 실패 (다시 시작하면 꺼져요): $($_.Exception.Message)" }
        }
        Say "  $($p.Name): $msg"
    }
}

# 터미널: 모든 탭 관리자 권한. 기본 프로필은 지금 쓰는 걸 그대로 두고, 설정 파일이 없을 때만 정함
function Set-TerminalSettings([string]$bk) {
    $file = $script:TerminalFile
    $default = if (Test-Pwsh) { $ProfilePwsh } else { $ProfileWinPS }
    $t = Read-TerminalSettings
    if ($t.Error) { throw "설정 파일을 읽지 못해 그대로 둬요: $($t.Error)" }
    if ($t.Exists) {
        $j = $t.Json
        Copy-Item -LiteralPath $file -Destination (Join-Path $bk 'terminal_settings.json') -Force
        if ($j.defaultProfile) { $default = "$($j.defaultProfile)" }
        else { $j | Add-Member -NotePropertyName defaultProfile -NotePropertyValue $default -Force }
        if ($null -eq $j.profiles) { $j | Add-Member -NotePropertyName profiles -NotePropertyValue ([pscustomobject]@{ defaults = [pscustomobject]@{}; list = @() }) -Force }
        elseif ($j.profiles -is [array]) { $j | Add-Member -NotePropertyName profiles -NotePropertyValue ([pscustomobject]@{ defaults = [pscustomobject]@{}; list = $j.profiles }) -Force }
        if ($null -eq $j.profiles.defaults) { $j.profiles | Add-Member -NotePropertyName defaults -NotePropertyValue ([pscustomobject]@{}) -Force }
        $j.profiles.defaults | Add-Member -NotePropertyName elevate -NotePropertyValue $true -Force
        Write-TextFile $file ($j | ConvertTo-Json -Depth 32) 'utf8'
        Write-TextFile (Join-Path $bk 'terminal_applied.sha256') (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash
    } else {
        if (-not (Test-TerminalInstalled)) { Say '  터미널 앱 없음: 건너뜀'; return }
        New-Item -ItemType Directory -Path (Split-Path $file) -Force | Out-Null
        $json = "{`n    `"`$schema`": `"https://aka.ms/terminal-profiles-schema`",`n    `"defaultProfile`": `"$default`",`n    `"profiles`": {`n        `"defaults`": {`n            `"elevate`": true`n        },`n        `"list`": []`n    }`n}`n"
        Write-TextFile $file $json 'utf8'
        Write-TextFile (Join-Path $bk 'terminal_settings.created') ''
        Write-TextFile (Join-Path $bk 'terminal_applied.sha256') (Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash
    }
    Say "  터미널: 기본 프로필 $(Get-ProfileName $default), 모든 탭 관리자 권한"
}

function Set-ShellSettings($S) {
    try { Set-TerminalSettings $S.Bk } catch { Warn "터미널 설정 건너뜀: $($_.Exception.Message)" }
    # 시작 메뉴 명령 프롬프트·PowerShell 바로가기: 관리자 권한으로 실행 (원본은 백업)
    $lnkBk = Join-Path $S.Bk 'lnk'; New-Item -ItemType Directory -Force -Path $lnkBk | Out-Null
    $list = New-Object System.Collections.Generic.List[object]
    $done = 0; $already = 0
    try {
        foreach ($l in @(Get-ShellLinks)) {
            try {
                if (Test-LnkRunAs $l.FullName) { $already++; continue }
                $copy = Join-Path $lnkBk ('{0:00}_{1}' -f $list.Count, $l.Name)
                Copy-Item -LiteralPath $l.FullName -Destination $copy -Force
                $list.Add([pscustomobject]@{ Path = $l.FullName; Backup = $copy })
                Set-LnkRunAs $l.FullName; $done++
                Say "  관리자 실행: $($l.Name)"
            } catch { Warn "바로가기 설정 실패: $($l.Name) ($($_.Exception.Message))" }
        }
    } finally {
        Write-TextFile (Join-Path $lnkBk 'list.json') (ConvertTo-Json -InputObject @($list.ToArray()) -Depth 3)
    }
    Say "  바로가기: ${done}개 바꿈$(if ($already) { ", ${already}개는 이미 관리자 실행" })"
    try {
        $rs = "$((Get-WindowsReservedStorageState -ErrorAction Stop).ReservedStorageState)"
        if ($rs -eq 'Disabled') { Say '  예약된 저장소: 이미 꺼짐' }
        else { Set-WindowsReservedStorageState -State Disabled -ErrorAction Stop; Say '  예약된 저장소 끔' }
    } catch { Say "  예약된 저장소 끄기 건너뜀 (업데이트가 진행 중일 때는 안 돼요): $($_.Exception.Message)" }
}

# 프로그램 안에 품은 WU 스크립트 (단일 파일 배포용: 적용 때 ProgramData\BeSffy 에 써서 씀)
function Get-WuBodies {
    $h = @{}
    $h['WU-Pause.ps1'] = @'
# Windows Update 장기 일시정지 (BeSffy)
# - 예약 작업(\BeSffy\WU-RePause)이 부팅 때와 매일 실행해 일시정지를 유지합니다.
# - '업데이트 켜기'로 켜 둔 상태(UpdateMode=On)면 건드리지 않지만, 켠 지 3일이 지나면
#   '끄기'를 안 눌렀어도 자동으로 다시 끄고 일시정지합니다.
# - -Force 를 주면 상태와 관계없이 일시정지를 기록합니다.
param([switch]$Force)

$AutoOffDays = 3
$flagKey = 'HKLM:\SOFTWARE\BeSffy'
$mode = (Get-ItemProperty -Path $flagKey -Name UpdateMode -ErrorAction SilentlyContinue).UpdateMode
if (-not $Force -and $mode -eq 'On') {
    $since = (Get-ItemProperty -Path $flagKey -Name UpdateModeSince -ErrorAction SilentlyContinue).UpdateModeSince
    $t = [datetime]::MinValue
    $styles = [Globalization.DateTimeStyles]::AssumeUniversal -bor [Globalization.DateTimeStyles]::AdjustToUniversal
    $known = [datetime]::TryParse("$since", [Globalization.CultureInfo]::InvariantCulture, $styles, [ref]$t)
    if ($known -and ((Get-Date).ToUniversalTime() - $t).TotalDays -lt $AutoOffDays) { exit 0 }
    # 켠 지 3일이 지났거나 켠 시각을 알 수 없으면 다시 끔
    Set-ItemProperty -Path $flagKey -Name UpdateMode -Value 'Off' -Type String
}

$ux = 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings'
if (-not (Test-Path $ux)) { New-Item -Path $ux -Force | Out-Null }

$now = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ', [Globalization.CultureInfo]::InvariantCulture)
$end = '2046-01-01T00:00:00Z'

# 설정 화면이 허용하는 최대 일시정지 일수 (일부 빌드에서만 쓰이지만 해가 없음)
Set-ItemProperty -Path $ux -Name 'FlightSettingsMaxPauseDays' -Value 7300 -Type DWord

foreach ($n in 'PauseUpdatesStartTime', 'PauseFeatureUpdatesStartTime', 'PauseQualityUpdatesStartTime') {
    Set-ItemProperty -Path $ux -Name $n -Value $now -Type String
}
foreach ($n in 'PauseUpdatesExpiryTime', 'PauseFeatureUpdatesEndTime', 'PauseQualityUpdatesEndTime') {
    Set-ItemProperty -Path $ux -Name $n -Value $end -Type String
}
'@
    $h['WU-On.ps1'] = @'
# Windows 업데이트 켜기 (BeSffy)
# 일시정지를 풀고 설정의 Windows Update 화면을 엽니다. 업데이트를 마치면 '업데이트 끄기'를 실행하세요.

$flagKey = 'HKLM:\SOFTWARE\BeSffy'
if (-not (Test-Path $flagKey)) { New-Item -Path $flagKey -Force | Out-Null }
Set-ItemProperty -Path $flagKey -Name UpdateMode -Value 'On' -Type String
# 켠 시각 (3일이 지나면 예약 작업이 자동으로 다시 끔)
$now = (Get-Date).ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ssZ', [Globalization.CultureInfo]::InvariantCulture)
Set-ItemProperty -Path $flagKey -Name UpdateModeSince -Value $now -Type String

$ux = 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings'
foreach ($n in 'PauseUpdatesStartTime', 'PauseFeatureUpdatesStartTime', 'PauseQualityUpdatesStartTime',
               'PauseUpdatesExpiryTime', 'PauseFeatureUpdatesEndTime', 'PauseQualityUpdatesEndTime') {
    Remove-ItemProperty -Path $ux -Name $n -ErrorAction SilentlyContinue
}

Start-Process 'ms-settings:windowsupdate'

Write-Host ''
Write-Host '  Windows 업데이트를 켰어요.' -ForegroundColor Green
Write-Host '  설정 화면에서 [업데이트 확인]을 눌러 설치하세요.'
Write-Host '  다 끝나면 바탕화면의 [Windows 업데이트 끄기]를 실행하세요.'
Write-Host '  (깜빡해도 3일이 지나면 자동으로 다시 꺼져요)'
Write-Host ''
Read-Host '  Enter를 누르면 창이 닫혀요'
'@
    $h['WU-Off.ps1'] = @'
# Windows 업데이트 끄기 (BeSffy)
# 업데이트를 다시 장기 일시정지 상태로 돌립니다.

$flagKey = 'HKLM:\SOFTWARE\BeSffy'
if (-not (Test-Path $flagKey)) { New-Item -Path $flagKey -Force | Out-Null }
Set-ItemProperty -Path $flagKey -Name UpdateMode -Value 'Off' -Type String

& (Join-Path $PSScriptRoot 'WU-Pause.ps1') -Force

Write-Host ''
Write-Host '  Windows 업데이트를 껐어요. (다시 켤 때까지 일시정지)' -ForegroundColor Green
Write-Host '  업데이트 설치 후 다시 시작하라는 안내가 있었다면 PC를 다시 시작하세요.'
Write-Host ''
Read-Host '  Enter를 누르면 창이 닫혀요'
'@
    return $h
}

function Set-UpdateLock {
    $dst = $script:ToolsDst
    New-Item -ItemType Directory -Force -Path $dst | Out-Null
    $bodies = Get-WuBodies   # 프로그램 안에 품은 WU 스크립트 (별도 폴더 필요 없음)
    foreach ($n in $ToolFiles) { Write-TextFile (Join-Path $dst $n) $bodies[$n] 'utf8bom' }
    Set-RegDirect $HKLM $FlagKey 'UpdateMode' 'String' 'Off'
    Invoke-WuPause
    $ps = $script:PowerShellExe
    $action    = New-ScheduledTaskAction -Execute $ps -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$(Join-Path $dst 'WU-Pause.ps1')`""
    # -At 는 날짜/시간 개체로 (언어·지역이 다른 PC 에서 '3am' 같은 글자가 안 먹힐 수 있어서)
    $at3 = [datetime]::Today.AddHours(3)
    $triggers  = @((New-ScheduledTaskTrigger -AtStartup), (New-ScheduledTaskTrigger -Daily -At $at3))
    $principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
    $settings  = New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
    Register-ScheduledTask -TaskPath $TaskPath -TaskName $TaskName -Action $action -Trigger $triggers -Principal $principal -Settings $settings -Force | Out-Null
    New-Item -ItemType Directory -Force -Path $script:PublicDesk | Out-Null
    # 켜기/끄기 아이콘을 다르게 (바탕화면에서 한눈에 구분). imageres.dll 아이콘 (버전마다 모양은 조금 달라도 서로 구분됨)
    $imageres = Join-Path $env:SystemRoot 'System32\imageres.dll'
    $wuIcon = @{ 'WU-On.ps1' = "$imageres,101"; 'WU-Off.ps1' = "$imageres,100" }
    foreach ($n in $WuLinks.Keys) {
        New-RunAsShortcut (Join-Path $script:PublicDesk $n) $ps "-NoProfile -ExecutionPolicy Bypass -File `"$(Join-Path $dst $WuLinks[$n])`"" $wuIcon[$WuLinks[$n]]
    }
    # 확인
    $exp  = "$((Get-RegValue $HKLM 'SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' 'PauseUpdatesExpiryTime').Value)"
    $task = Get-ScheduledTask -TaskPath $TaskPath -TaskName $TaskName -ErrorAction SilentlyContinue
    $links = @($WuLinks.Keys | Where-Object { Test-Path -LiteralPath (Join-Path $script:PublicDesk $_) })
    if ($exp -ne $PauseEnd) { Warn "일시정지 만료가 $PauseEnd 로 들어가지 않았어요 (지금: $(if ($exp) { $exp } else { '없음' }))" }
    if (-not $task) { Warn '예약 작업 WU-RePause 를 만들지 못했어요' }
    if ($links.Count -lt $WuLinks.Count) { Warn '바탕화면 업데이트 켜기/끄기 바로가기를 다 만들지 못했어요' }
    Say "  일시정지 만료: $exp / 버전 고정: $(if ($script:DisplayVersion) { $script:DisplayVersion } else { '건너뜀' }) / 예약 작업 $TaskPath$TaskName / 바탕화면 켜기·끄기 바로가기 $($links.Count)개"
}

function Remove-OneDrive($od) {
    if (-not $od -or -not $od.Installed) { Say '  설치돼 있지 않음 (동기화 막기 정책만 적용)'; return }
    Stop-OneDrive
    foreach ($u in $od.Uninstall) {
        # 'C:\...\OneDriveSetup.exe  /uninstall' 또는 '"..." /uninstall /allusers'
        if ($u.Cmd -match '^\s*"?(?<exe>[^"]+?\.exe)"?\s*(?<args>.*)$') {
            $exe = $Matches.exe; $uargs = $Matches.args.Trim()
            if (-not $uargs) { $uargs = '/uninstall' }
            try { Say "  제거 실행 ($($u.Scope)): 종료 코드 $(Start-Uninstaller $exe $uargs)" }
            catch { Warn "OneDrive 제거 실행 실패 ($($u.Scope)): $($_.Exception.Message)" }
        } else { Warn "OneDrive 제거 명령을 알아보지 못했어요: $($u.Cmd)" }
    }
    Start-Sleep -Seconds 3
    if ((Get-OneDriveInfo -NoScan).Installed) { Warn 'OneDrive 가 아직 설치돼 있어요. 설정 → 앱 → 설치된 앱에서 지워 주세요.' }
    else { Say '  OneDrive 제거됨 (폴더와 파일은 그대로)' }
}

function Remove-Apps($S) {
    try {
        Stop-AppProcesses $S.Sel   # 실행 중이면 먼저 내림 (제거 실패 방지)
        # 순서: 새 사용자용(프로비저닝)을 먼저 지움. 모든 사용자에게서 먼저 지우면 앱 파일이 사라져서
        # 프로비저닝 지우기가 '지정된 경로를 찾을 수 없습니다'로 실패함
        foreach ($n in $S.Sel) {
            foreach ($p in @(Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object DisplayName -eq $n)) {
                if (-not (Test-ProvFiles $p)) { continue }   # 파일이 이미 없는 기록은 지울 수 없고, 새 사용자에게 설치되지도 않음
                try { Remove-AppxProvisionedPackage -Online -PackageName $p.PackageName -ErrorAction Stop | Out-Null }
                catch { Say "  ($n 새 사용자용 지우기: $($_.Exception.Message.Trim()))" }
            }
            foreach ($pkg in @(Get-AppxPackage -AllUsers -Name $n -ErrorAction SilentlyContinue)) {
                try { Remove-AppxPackage -Package $pkg.PackageFullName -AllUsers -ErrorAction Stop }
                catch { Say "  ($n 지우기: $($_.Exception.Message.Trim()))" }
            }
        }
    } finally {
        # 실제로 남은 것만 알리고, 지워진 것만 기록 (점검 때 '다시 생김' 판단에 씀)
        Clear-AppxCache
        $users = @(Get-AppxPackage -AllUsers -ErrorAction SilentlyContinue)
        $prov  = @(Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue)
        $gone = New-Object System.Collections.Generic.List[string]
        foreach ($n in $S.Sel) {
            $u = @($users | Where-Object Name -eq $n)
            $p = @($prov | Where-Object DisplayName -eq $n)
            if ($u.Count) { Warn "$(Get-AppLabel $n) ($n) 이(가) 아직 설치돼 있어요" }
            elseif ($p | Where-Object { Test-ProvFiles $_ }) { Warn "$(Get-AppLabel $n) ($n) 새 사용자용이 아직 남아 있어요" }
            else {
                $gone.Add($n)
                if ($p.Count) { Say "  지움: $(Get-AppLabel $n) (새 사용자용 기록만 남음: 파일이 없어 새 사용자에게 설치되지 않음)" } else { Say "  지움: $(Get-AppLabel $n)" }
            }
        }
        Write-TextFile (Join-Path $S.Bk 'applied_apps.txt') ((@('# 이 적용에서 지운 앱') + $gone.ToArray()) -join "`r`n")
    }
}

function Remove-Components {
    Write-Host '   (시스템 구성요소를 정리하는 중이에요. 항목마다 수십 초~1분 걸릴 수 있어요...)' -ForegroundColor DarkGray
    foreach ($c in Get-CapStatus) {
        if ($c.State -ne 'Installed') { Say "  $(if ($c.State -eq '확인 못 함') { '확인 못 함' } else { '이미 없음' }): $($c.Label)"; continue }
        try { Remove-WindowsCapability -Online -Name $c.Name -ErrorAction Stop | Out-Null; Say "  지움: $($c.Label)" }
        catch { Warn "$($c.Label) 지우기 실패: $($_.Exception.Message)" }
    }
    if ((Get-RecallState) -eq 'Enabled') {
        try { Disable-WindowsOptionalFeature -Online -FeatureName Recall -Remove -NoRestart -ErrorAction Stop | Out-Null; Say '  지움: Recall' }
        catch { Warn "Recall 지우기 실패: $($_.Exception.Message)" }
    } else { Say '  이미 없음: Recall' }
}

# ============================== 되돌리기 ==============================
# 적용을 여러 번 했으면 백업도 여러 개: 최근 것부터 차례로 되돌려야 맨 처음(적용 전) 상태로 돌아감
function Invoke-Undo {
    $script:UndoDone = $false
    $all = @(Get-Backups | Sort-Object Name -Descending)
    Head '되돌리기'
    if (-not $all.Count) { Say '  되돌릴 백업이 없어요.'; return }
    Say "  되돌릴 백업 $($all.Count)개 (최근 것부터 차례로, 끝나면 맨 처음 적용 전 상태): $(($all | ForEach-Object Name) -join ', ')"
    Say '  지운 앱·구성요소·OneDrive 는 되돌리지 않아요 (스토어·설정 → 선택적 기능·복원 지점으로).'
    if (-not (Ask '되돌릴까요?')) { Say '  취소했어요. 아무것도 바꾸지 않았어요.'; return }
    $done = Join-Path $script:BackupRoot "undone_$($script:Stamp)"
    New-Item -ItemType Directory -Force -Path $done | Out-Null
    foreach ($b in $all) {
        try { Undo-OneBackup $b.FullName }
        catch { Warn "되돌리기 중 오류 ($($b.Name)), 나머지는 계속해요: $($_.Exception.Message)" }
        # 실패해도 옮김: 남겨 두면 다음 되돌리기에서 이 백업만 다시 적용돼 '첫 적용 뒤' 상태로 돌아가 버림
        Move-Item -LiteralPath $b.FullName -Destination $done -Force
    }
    Head '끝'
    Say '  되돌리기 끝. 다시 시작해야 모두 원래대로 돌아와요.'
    Say "  되돌린 백업은 $done 로 옮겨 뒀어요."
    $file = Write-Report 'undo' '되돌리기 결과'
    Show-WarnSummary
    Write-Host "`n결과 보고서: $file" -ForegroundColor Green
    $script:UndoDone = $true
}
function Undo-OneBackup([string]$bk) {
    $st = Read-State $bk
    Head "되돌리기: $(Split-Path $bk -Leaf) (적용 계정 $($st.User))"
    if ($st.User -and $st.User -ne (Get-CurrentUserName)) { Warn '적용했던 계정과 지금 계정이 달라요. 사용자 설정은 지금 계정에 되돌려져요.' }

    # 0. 이 백업 뒤에 꺼져 있던 검색 색인을 켰으면 (적용의 '켜 두기'나 메뉴 5) 먼저 다시 끔. 그다음 이 백업의 원래 값으로 되돌림
    if ((Test-Path -LiteralPath (Join-Path $bk 'search_was_off.txt')) -and (Get-Service -Name WSearch -ErrorAction SilentlyContinue)) {
        $null = Set-ServiceStartType 'WSearch' 'disabled'
        try { Stop-Service -Name WSearch -Force -ErrorAction Stop } catch {}
        Say '  검색 색인: 켜기 전 상태(꺼짐)로 되돌림'
    }
    # 1. 레지스트리: 지운 키 복원 → 값 되돌림 → 적용 때 새로 생긴 빈 키 정리
    foreach ($f in @(Get-ChildItem -LiteralPath $bk -Filter 'deleted_key_*.reg' -File | Where-Object Name -notlike 'deleted_key_default_*')) {
        $r = Import-Reg $f.FullName
        if ($r.Code -eq 0) { Say "  키 복원: $($f.Name)" } else { Warn "키 복원 실패: $($f.Name) ($($r.Text))" }
    }
    $u = Join-Path $bk 'undo_values.reg'
    if (Test-Path -LiteralPath $u) {
        $r = Import-Reg $u
        if ($r.Code -eq 0) { Say '  레지스트리 값 되돌림' } else { Warn "레지스트리 값 일부를 되돌리지 못했어요 ($($r.Text))" }
    }
    $n = Remove-NewKeys $st.NewKeys
    if ($n) { Say "  적용 때 새로 생긴 빈 키 ${n}개 지움" }
    $ud = Join-Path $bk 'undo_values_defaultuser.reg'
    if ($st.DefaultUser -and (Test-Path -LiteralPath $ud)) {
        if (Mount-DefaultHive) {
            try {
                foreach ($f in @(Get-ChildItem -LiteralPath $bk -Filter 'deleted_key_default_*.reg' -File)) {
                    $r = Import-Reg $f.FullName
                    if ($r.Code -ne 0) { Warn "새 사용자 키 복원 실패: $($f.Name) ($($r.Text))" }
                }
                $r = Import-Reg $ud
                if ($r.Code -eq 0) { Say '  새 사용자 기본값 되돌림' } else { Warn "새 사용자 기본값 일부를 되돌리지 못했어요 ($($r.Text))" }
                $null = Remove-NewKeys $st.NewKeysDefault
            } finally { Dismount-DefaultHive }
        }
    }

    # 2. 서비스: 되돌린 레지스트리 시작 유형을 서비스 관리자에도 반영하고, 켜져 있던 건 다시 켬
    if ($st.Services) {
        foreach ($p in $st.Services.PSObject.Properties) {
            $status = if ($p.Value -is [string]) { $p.Value } else { "$($p.Value.Status)" }   # 예전 형식: 상태만 있음
            if (-not (Get-Service -Name $p.Name -ErrorAction SilentlyContinue)) { continue }
            $sc = Get-ScTypeFromRegistry $p.Name
            if ($sc) { $null = Set-ServiceStartType $p.Name $sc }
            if ($status -eq 'Running') {
                try { Start-Service -Name $p.Name -ErrorAction Stop; Say "  서비스 다시 켬: $($p.Name)" }
                catch { Say "  $($p.Name): 지금 켜지 못했어요 (다시 시작하면 원래대로 켜져요)" }
            } elseif ($sc) { Say "  서비스 시작 유형 되돌림: $($p.Name) ($sc)" }
        }
    }

    # 2-2. Defender 예약 검사: 적용 전 값으로
    if ($st.PSObject.Properties['Defender'] -and $st.Defender) {
        try { Set-DefenderScanPref $st.Defender; Say "  Defender 예약 검사 되돌림 ($(Format-DefenderPref $st.Defender))" }
        catch { Warn "Defender 예약 검사 설정을 되돌리지 못했어요: $("$($_.Exception.Message)".Trim())" }
    }

    # 3. 업데이트 잠금: 적용 전에 없던 것만 지움 (예전 LiteTools 이름으로 만든 것도 같이 정리)
    if ($st.HadTask -eq $false) {
        Unregister-ScheduledTask -TaskPath $TaskPath -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
        Unregister-ScheduledTask -TaskPath $TaskPathOld -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
        Say '  예약 작업 WU-RePause 지움'
    }
    $hadLinks = if ($null -ne $st.HadLinks) { @($st.HadLinks) } elseif ($st.HadTools) { @($WuLinks.Keys) } else { @() }
    $rm = @($WuLinks.Keys | Where-Object { $hadLinks -notcontains $_ -and (Test-Path -LiteralPath (Join-Path $script:PublicDesk $_)) })
    foreach ($l in $rm) { Remove-Item -LiteralPath (Join-Path $script:PublicDesk $l) -Force -ErrorAction SilentlyContinue }
    if ($rm.Count) { Say "  바탕화면 업데이트 켜기/끄기 바로가기 $($rm.Count)개 지움" }
    if ($st.HadTools -eq $false) {
        foreach ($d in @($script:ToolsDst, $script:ToolsDstOld)) {
            if ($d -and (Test-Path -LiteralPath $d)) { Remove-Item -LiteralPath $d -Recurse -Force -ErrorAction SilentlyContinue; Say "  도구 폴더 지움 ($d)" }
        }
    }

    # 4. 터미널
    try { Undo-Terminal $bk } catch { Warn "터미널 설정 되돌리기 실패: $($_.Exception.Message)" }

    # 5. 시작 메뉴 바로가기: 바꾼 것(관리자 실행 표시)만 되돌림. 그 뒤 앱 업데이트로 바뀐 바로가기도 망가지지 않게
    $ll = Join-Path $bk 'lnk\list.json'
    $raw = if (Test-Path -LiteralPath $ll) { Read-TextFile $ll } else { '' }
    if ($raw -and $raw.Trim()) {
        $n = 0
        # PowerShell 5.1 의 ConvertFrom-Json 은 배열을 펼치지 않고 통째로 하나로 내보냄 → 변수에 받은 뒤 foreach (@() 로 감싸면 안 됨)
        $arr = $raw | ConvertFrom-Json
        foreach ($l in $arr) {
            if (-not $l -or -not $l.Path) { continue }
            try {
                # 예전 형식 백업은 원래부터 관리자 실행이던 바로가기도 목록에 있음 → 백업본이 관리자 실행이면 그대로 둠
                $wasRunAs = [bool]($l.Backup -and (Test-Path -LiteralPath $l.Backup) -and (Test-LnkRunAsSafe $l.Backup))
                if (Test-Path -LiteralPath $l.Path) { if (-not $wasRunAs) { Clear-LnkRunAs $l.Path; $n++ } }
                elseif ($l.Backup -and (Test-Path -LiteralPath $l.Backup) -and (Test-Path -LiteralPath (Split-Path $l.Path))) { Copy-Item -LiteralPath $l.Backup -Destination $l.Path -Force; $n++ }
            } catch { Warn "바로가기 되돌리기 실패: $($l.Path) ($($_.Exception.Message))" }
        }
        Say "  시작 메뉴 바로가기 ${n}개 되돌림"
    }

    # 6. 예약된 저장소
    if ("$($st.ReservedStorage)" -eq 'Enabled') {
        try {
            if ("$((Get-WindowsReservedStorageState -ErrorAction Stop).ReservedStorageState)" -ne 'Enabled') {
                Set-WindowsReservedStorageState -State Enabled -ErrorAction Stop; Say '  예약된 저장소 다시 켬'
            }
        } catch { Warn "예약된 저장소를 다시 켜지 못했어요: $($_.Exception.Message)" }
    }
}

# 터미널 설정 되돌리기: 적용 뒤 그대로면 원래 파일로, 그 뒤 사용자가 바꾼 게 있으면 '모든 탭 관리자 권한'만 원래대로
# (어느 경우든 지금 파일은 백업 폴더에 terminal_settings.before_undo.json 으로 남김)
function Undo-Terminal([string]$bk) {
    $tf = $script:TerminalFile
    $orig    = Join-Path $bk 'terminal_settings.json'
    $created = Join-Path $bk 'terminal_settings.created'
    $hasOrig = Test-Path -LiteralPath $orig
    if (-not $hasOrig -and -not (Test-Path -LiteralPath $created)) { return }
    if (-not (Test-Path -LiteralPath $tf)) {
        if ($hasOrig) { New-Item -ItemType Directory -Force -Path (Split-Path $tf) | Out-Null; Copy-Item -LiteralPath $orig -Destination $tf -Force; Say '  터미널 설정 되돌림 (파일이 없어서 원래 파일로)' }
        return
    }
    Copy-Item -LiteralPath $tf -Destination (Join-Path $bk 'terminal_settings.before_undo.json') -Force
    $hf = Join-Path $bk 'terminal_applied.sha256'
    $untouched = (Test-Path -LiteralPath $hf) -and ((Read-TextFile $hf).Trim() -eq (Get-FileHash -LiteralPath $tf -Algorithm SHA256).Hash)
    if ($untouched) {
        if ($hasOrig) { Copy-Item -LiteralPath $orig -Destination $tf -Force; Say '  터미널 설정 되돌림' }
        else { Remove-Item -LiteralPath $tf -Force; Say '  만들었던 터미널 설정 지움' }
        return
    }
    $cur = Read-TerminalSettings
    if ($cur.Error) {
        if ($hasOrig) { Copy-Item -LiteralPath $orig -Destination $tf -Force; Say '  터미널 설정을 원래 파일로 되돌림 (지금 파일을 읽지 못해서. 지금 파일은 백업 폴더에 남김)' }
        else { Warn "터미널 설정 파일을 읽지 못해 관리자 권한 설정을 되돌리지 못했어요: $($cur.Error)" }
        return
    }
    $origElev = $null
    if ($hasOrig) {
        try {
            $o = (Remove-JsonComments (Read-TextFile $orig)) | ConvertFrom-Json
            if ($o.profiles -and $o.profiles -isnot [array] -and $o.profiles.defaults) {
                $pp = $o.profiles.defaults.PSObject.Properties['elevate']; if ($pp) { $origElev = $pp.Value }
            }
        } catch {}
    }
    $j = $cur.Json
    if ($j.profiles -and $j.profiles -isnot [array] -and $j.profiles.defaults -and $j.profiles.defaults.PSObject.Properties['elevate']) {
        if ($null -ne $origElev) { $j.profiles.defaults.elevate = $origElev } else { $j.profiles.defaults.PSObject.Properties.Remove('elevate') }
        Write-TextFile $tf ($j | ConvertTo-Json -Depth 32) 'utf8'
    }
    Say '  터미널: 모든 탭 관리자 권한만 원래대로 (적용 뒤 바꾼 다른 설정은 그대로)'
}

# ============================== 실행 ==============================
# 한 가지 작업(미리보기·적용·점검·되돌리기)을 처음부터 한 번 돌림. 돌릴 때마다 상태를 새로 읽고 보고서·로그를 따로 남김
# 반환: 적용·되돌리기를 끝냈으면 $true (부른 쪽에서 '다시 시작할까요?'를 물음)
# ============================== 메뉴 5: 백그라운드 다시 켜기 ==============================
# 적용으로 막힌 스토어 앱 중 골라서 다시 켬(또는 더 끔). 백그라운드 허용 목록 레지스트리 값 하나만 바꿈
$AppPrivacyKey = 'SOFTWARE\Policies\Microsoft\Windows\AppPrivacy'
function Invoke-BgEdit {
    $script:BgEditDone = $false
    Head '백그라운드 다시 켜기 (막힌 앱 골라서 허용)'
    $mode = Get-RegValue $HKLM $AppPrivacyKey 'LetAppsRunInBackground'
    if (-not $mode.Exists -or ([int64]$mode.Value -band 4294967295) -ne 2) {
        Say '  스토어 앱 백그라운드 금지가 걸려 있지 않아요 (아직 적용 안 했거나 되돌렸음). 지금은 모든 앱이 백그라운드에서 돌 수 있어서 바꿀 게 없어요.'
        return
    }
    $curV = Get-RegValue $HKLM $AppPrivacyKey 'LetAppsRunInBackground_ForceAllowTheseApps'
    $cur = @(); if ($curV.Exists) { $cur = @(@($curV.Value) | Where-Object { $_ }) }
    $extraNow = @($cur | Where-Object { $BgAlways -notcontains $_ })
    $cand = @(Get-BgCandidates -Detail)
    if ($script:BgReadError) { Warn "설치된 앱 목록을 읽지 못했어요 ($($script:BgReadError)). 아무것도 바꾸지 않았어요."; return }
    if (-not $cand.Count) { Say '  고를 스토어 앱이 이 PC 에 없어요.'; return }
    $def = @(Get-BgDefaultFamilies)
    $blocked = @($cand | Where-Object { $extraNow -notcontains $_.Family })
    Say "  지금 백그라운드 켜 둠: 휴대폰과 연결 + $($extraNow.Count)개 / 막힘: $($blocked.Count)개"
    $recOff = @($blocked | Where-Object Rec)
    if ($recOff.Count) { Say "  막혀 있는 추천(★) 항목: $(($recOff | ForEach-Object Label) -join ', ')" }
    $pre = $extraNow
    # 예전 버전(빈 창) 때문에 휴대폰과 연결만 켜져 있으면 추천을 미리 체크해 둠 (일부러 비운 경우는 그대로)
    if (-not $extraNow.Count -and $null -eq (Read-BgSelection) -and $def.Count) {
        $pre = $def
        Say '  지금 예외가 휴대폰과 연결뿐이에요 (예전 버전에서 고르는 창이 빈칸으로 뜬 문제). 추천(★) 항목을 미리 체크해 뒀어요.'
    }
    Say '  고르는 창이 열려요. 켜 둘 것만 체크하세요 (프로그램을 체크하면 아래 항목이 모두 같이 켜져요).'
    $picked = Show-BgPicker $cand $pre $def -Restore
    if ($null -eq $picked) { Say '  취소했어요. 아무것도 바꾸지 않았어요.'; return }
    # 목록에 없는 기존 예외(지운 앱 등)는 그대로 둠
    $candFam = @($cand | ForEach-Object Family)
    $keep = @($extraNow | Where-Object { $candFam -notcontains $_ })
    $newExtra = @(@($picked) + $keep | Where-Object { $_ } | Sort-Object -Unique)
    $on  = @($newExtra | Where-Object { $extraNow -notcontains $_ })
    $off = @($extraNow | Where-Object { $newExtra -notcontains $_ })
    $lab = { param($fam) $m = $cand | Where-Object Family -eq $fam | Select-Object -First 1; if ($m) { $m.Label } else { $fam -replace '_[^_]+$', '' } }
    if (-not $on.Count -and -not $off.Count) { Save-BgSelection $newExtra; Say '  바뀐 게 없어요.'; return }
    if ($on.Count)  { Say "  다시 켬 (백그라운드 허용) $($on.Count)개: $(($on | ForEach-Object { & $lab $_ }) -join ', ')" }
    if ($off.Count) { Say "  끔 (백그라운드 금지) $($off.Count)개: $(($off | ForEach-Object { & $lab $_ }) -join ', ')" }
    if (-not (Ask '  이대로 바꿀까요?')) { Say '  취소했어요. 아무것도 바꾸지 않았어요.'; return }

    Set-BgExtra $newExtra   # 레지스트리 항목을 새 목록으로 다시 만듦 (BgAllowed = 휴대폰과 연결 + 고른 것)
    $item = @($script:Reg | Where-Object Name -eq 'LetAppsRunInBackground_ForceAllowTheseApps')
    $f = Join-Path $script:ReportDir "background_$($script:Stamp).reg"
    Write-RegFile $f (Build-ApplyLines $item)
    $null = Import-Reg $f
    $bad = Test-RegApplied $item
    if ($bad) {
        Warn '백그라운드 허용 목록을 바꾸지 못했어요. 위 이유를 확인하세요.'
        $file = Write-Report 'background' '백그라운드 다시 켜기 (실패)'; Show-WarnSummary; return
    }
    Save-BgSelection $newExtra
    # 마지막 적용 기록에도 남김 (점검이 이 목록과 비교하도록. 되돌리기는 그대로 처음 값으로 돌림)
    $bks = @(Get-Backups)
    if ($bks.Count) {
        $lines = @("# 메뉴 5 로 바꾼 백그라운드 허용 목록 ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))") + $newExtra
        Write-TextFile (Join-Path $bks[-1].FullName 'bgapps_changed.txt') (($lines -join "`r`n") + "`r`n")
    }
    Head '끝'
    Say "  바꿨어요. 지금 백그라운드 켜 둠: 휴대폰과 연결 + $($newExtra.Count)개"
    Say '  다시 시작(또는 로그아웃 뒤 다시 로그인)해야 확실히 적용돼요. 다시 켠 앱은 한 번 껐다 켜 주세요.'
    $file = Write-Report 'background' '백그라운드 다시 켜기 결과' @("다시 켬: $(($on | ForEach-Object { & $lab $_ }) -join ', ')", "끔: $(($off | ForEach-Object { & $lab $_ }) -join ', ')")
    Show-WarnSummary
    Write-Host "`n결과 보고서: $file" -ForegroundColor Green
    $script:BgEditDone = $true
}

# ---- 메뉴 5 의 2: 검색 색인 다시 켜기 ----
# BeSffy 가 끄기 전 WSearch 시작 유형 (가장 처음 백업의 기록). 기록이 없으면 Windows 기본값(자동-지연된 시작)
function Get-SearchOrigSc {
    foreach ($b in @(Get-Backups)) {
        $st = Read-State $b.FullName
        if ($st.Services -and $st.Services.PSObject.Properties['WSearch']) {
            $v = $st.Services.WSearch
            if ($v -isnot [string] -and "$($v.Sc)" -and "$($v.Sc)" -ne 'disabled') { return "$($v.Sc)" }
        }
    }
    return 'delayed-auto'
}
# 검색 색인을 켜 둔 상태로 기록: 다음 적용 때 다시 끄지 않게 선택값을 바꾸고, 마지막 적용 기록에 표시 (점검이 '꺼져 있어야 함'이라고 하지 않게)
# -WasOff: 이번에 꺼져 있던 걸 켰음 → 되돌리기 때 그 백업을 되돌리기 전에 먼저 다시 끔 (켜기 전 상태로)
function Set-SearchKept([switch]$WasOff) {
    # 선택값 파일이 있을 때만 바꿈 (없으면 새로 만들지 않음: 만들면 다음 적용 때 '무엇을 적용할까요' 창이 안 뜨고 기본값으로 적용됨)
    $o = Read-Options
    if ($null -ne $o) { $o['DisableSearch'] = $false; Save-Options $o }
    $bks = @(Get-Backups)
    if ($bks.Count) {
        Write-TextFile (Join-Path $bks[-1].FullName 'search_on.txt') "# 검색 색인 켜 둠 ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))`r`n"
        if ($WasOff) { Write-TextFile (Join-Path $bks[-1].FullName 'search_was_off.txt') "# 꺼져 있던 검색 색인을 켰음 ($(Get-Date -Format 'yyyy-MM-dd HH:mm'))`r`n" }
    }
}
function Invoke-SearchOn {
    $script:SearchOnDone = $false
    Head '검색 색인 다시 켜기'
    if (-not (Get-Service -Name WSearch -ErrorAction SilentlyContinue)) { Say '  이 PC 에는 검색 서비스(WSearch)가 없어요.'; return }
    $hist = Get-AppliedInfo
    $now = Get-ScTypeFromRegistry 'WSearch'
    if ($now -ne 'disabled') {
        $svc = Get-Service -Name WSearch -ErrorAction SilentlyContinue
        Say "  검색 색인은 이미 켜져 있어요 (시작 유형 $($svc.StartType), 지금 $($svc.Status))."
        if ($hist -and $hist.Flags.DisableSearch) { Set-SearchKept; Say "  BeSffy 기록에도 '검색 색인 켜 둠'으로 남겼어요. 이제 점검에서 꺼져 있어야 한다고 하지 않고, 다시 적용해도 끄지 않아요." }
        return
    }
    $sc = Get-SearchOrigSc
    Say "  지금: 사용 안 함 (꺼짐). 다시 켜면 시작 유형을 원래대로 '$(Get-ScLabel $sc)' 로 돌리고 바로 켜요."
    Say '  (파일·메일 검색이 빨라지는 대신, 처음 색인을 만드는 동안 디스크·CPU 를 조금 써요)'
    if (-not (Ask '  검색 색인을 다시 켤까요?')) { Say '  취소했어요. 아무것도 바꾸지 않았어요.'; return }
    if (-not (Enable-SearchIndex)) { $file = Write-Report 'search' '검색 색인 다시 켜기 (실패)'; Show-WarnSummary; return }
    Set-SearchKept -WasOff
    Say '  다음에 적용(메뉴 2)을 해도 검색 색인은 다시 끄지 않아요. 다시 끄려면 미리보기의 검색 색인 창에서 "끄기"를 고르고 적용하세요.'
    Head '끝'
    $file = Write-Report 'search' '검색 색인 다시 켜기 결과'
    Show-WarnSummary
    Write-Host "`n결과 보고서: $file" -ForegroundColor Green
    $script:SearchOnDone = $true
}
function Get-ScLabel([string]$sc) { switch ($sc) { 'delayed-auto' { '자동(지연된 시작)' } 'auto' { '자동' } 'demand' { '수동' } default { $sc } } }
# 검색 색인을 원래 시작 유형으로 켬 (sc.exe → 안 되면 레지스트리 직접). 성공하면 $true
function Enable-SearchIndex {
    $sc = Get-SearchOrigSc
    $r = Set-ServiceStartType 'WSearch' $sc
    if ((Get-ScTypeFromRegistry 'WSearch') -ne $sc) {
        # sc.exe 가 안 되면 레지스트리에 직접 (다시 시작하면 맞춰짐)
        try {
            $k = 'SYSTEM\CurrentControlSet\Services\WSearch'
            Set-RegDirect $HKLM $k 'Start' 'DWord' $(if ($sc -eq 'demand') { 3 } else { 2 })
            if ($sc -eq 'delayed-auto') { Set-RegDirect $HKLM $k 'DelayedAutostart' 'DWord' 1 }
            elseif ($sc -eq 'auto') { Set-RegDirect $HKLM $k 'DelayedAutostart' 'DWord' 0 }
        } catch {}
    }
    if ((Get-ScTypeFromRegistry 'WSearch') -ne $sc) { Warn "검색 색인 시작 유형을 바꾸지 못했어요 ($($r.Text))."; return $false }
    Say "  검색 색인 시작 유형: $(Get-ScLabel $sc)"
    if ($sc -ne 'demand') {
        try { Start-Service -Name WSearch -ErrorAction Stop; Say '  검색 색인을 켰어요. 처음엔 색인을 만드느라 검색 결과가 조금 늦게 채워질 수 있어요.' }
        catch { Say "  지금 바로 켜지는 못했어요. 다시 시작하면 켜져요. ($($_.Exception.Message))" }
    }
    return $true
}
# ---- 메뉴 5 의 3: 시작 프로그램 다시 켜기 ----
# 지금 꺼져 있는 시작 프로그램(BeSffy 로 껐든 작업 관리자로 껐든) 중 골라서 켬. 다음 적용 때 다시 끄지 않게 고른 값에서도 뺌
function Invoke-StartupOn {
    Head '시작 프로그램 다시 켜기'
    $su = @(Get-StartupItems | Where-Object { -not $_.On })
    if (-not $su.Count) { Say '  지금 꺼져 있는 시작 프로그램이 없어요.'; return }
    Say "  지금 로그인할 때 안 켜지는 프로그램 $($su.Count)개: $(($su | ForEach-Object Label) -join ', ')"
    $want = @{}; foreach ($it in $su) { $want[$it.Id] = $false }
    Say '  고르는 창이 열려요. 다시 켤 것만 체크하세요.'
    $pick = Show-StartupPicker $su $want -Restore
    if ($null -eq $pick) { Say '  취소했어요. 아무것도 바꾸지 않았어요.'; return }
    $plan = @(Get-StartupChanges $su $pick)
    if (-not $plan.Count) { Say '  고른 게 없어요. 아무것도 바꾸지 않았어요.'; return }
    Say "  다시 켤 것 $($plan.Count)개: $(($plan | ForEach-Object Label) -join ', ')"
    if (-not (Ask '  이대로 다시 켤까요?')) { Say '  취소했어요. 아무것도 바꾸지 않았어요.'; return }
    $items = @(foreach ($c in $plan) {
        $t = Get-StartupTarget $c.Id
        [pscustomobject]@{ Cat = 'Startup'; Hive = $t.Hive; Key = $t.Key; Name = $t.Name; Kind = $t.Kind; Value = $t.On; Desc = "시작 프로그램 켬: $($c.Label)"; CurOnly = $true; Skip = $null }
    })
    $f = Join-Path $script:ReportDir "startup_$($script:Stamp).reg"
    Write-RegFile $f (Build-ApplyLines $items)
    $null = Import-Reg $f
    $bad = Test-RegApplied $items
    $sel = Read-StartupSelection
    if ($null -ne $sel) { Save-StartupSelection @($sel | Where-Object { @($plan | ForEach-Object Id) -notcontains $_.Id }) }
    Head '끝'
    Say "  다시 켰어요: $($plan.Count - $bad)개. 다음에 로그인할 때부터 자동으로 켜져요."
    Say '  다음 적용(메뉴 2) 때도 다시 끄지 않아요. 다시 끄려면 미리보기의 시작 프로그램 창에서 체크를 풀고 적용하세요.'
    $file = Write-Report 'startup' '시작 프로그램 다시 켜기 결과' @("다시 켬: $(($plan | ForEach-Object Label) -join ', ')")
    Show-WarnSummary
    Write-Host "`n결과 보고서: $file" -ForegroundColor Green
}

# 메뉴 5: 일부 옵션만 복구 - 무엇을 다시 켤지 고름
function Invoke-Restore {
    Head '일부 옵션만 복구 (다시 켜기)'
    $pm = Get-RegValue $HKLM $AppPrivacyKey 'LetAppsRunInBackground'
    $bgBlocked = $pm.Exists -and (([int64]$pm.Value -band 4294967295) -eq 2)
    $ws = if (Get-Service -Name WSearch -ErrorAction SilentlyContinue) { Get-ScTypeFromRegistry 'WSearch' } else { $null }
    $wsTxt = if ($null -eq $ws) { '이 PC 에 없음' } elseif ($ws -eq 'disabled') { '꺼져 있음' } else { '켜져 있음' }
    Say "  1. 백그라운드 앱 다시 켜기 - 막힌 스토어 앱(서비스)을 프로그램별로 골라서 허용 (지금: $(if ($bgBlocked) { '스토어 앱 백그라운드 금지 걸림' } else { '금지 안 걸림' }))"
    Say "  2. 검색 색인 다시 켜기     - Windows 검색 색인(WSearch)을 원래대로 켬 (지금: $wsTxt)"
    Say "  3. 시작 프로그램 다시 켜기 - 로그인할 때 안 켜지게 해 둔 프로그램을 골라서 다시 켬"
    $c = "$(Read-Host '  번호를 고르세요 (Enter 는 메뉴로)')".Trim()
    switch ($c) {
        '1'     { Invoke-BgEdit }
        '2'     { Invoke-SearchOn }
        '3'     { Invoke-StartupOn }
        default { Say '  아무것도 고르지 않았어요. 메뉴로 돌아가요.' }
    }
}

function Invoke-One([string]$RunMode) {
    $script:Mode = $RunMode
    $script:Out  = New-Object System.Collections.Generic.List[string]
    $script:Warn = New-Object System.Collections.Generic.List[string]
    $script:Stamp = New-Stamp
    $script:UserMismatch = $false
    $script:ApplyDone = $false; $script:UndoDone = $false; $script:BgEditDone = $false; $script:SearchOnDone = $false
    Clear-AppxCache   # 작업마다 앱 목록을 새로 읽음
    $log = Join-Path $script:ReportDir "$($RunMode.ToLower())_$($script:Stamp).log"
    $tr = $false
    try { Start-Transcript -Path $log -ErrorAction Stop | Out-Null; $tr = $true } catch {}
    try {
        Initialize-Context   # 작업마다 새로 (앞서 적용한 결과가 반영되도록)
        switch ($RunMode) {
            'Preview' { Invoke-Report }
            'Check'   { Invoke-Report }
            'Apply'   { Invoke-Apply }
            'Undo'    { Invoke-Undo }
            'Background' { Invoke-BgEdit }
            'Search'     { Invoke-SearchOn }
            'Restore'    { Invoke-Restore }
        }
    } catch {
        Write-Host "`n오류: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host $_.ScriptStackTrace
        $script:Warn.Add("실행 중 오류로 멈춤: $($_.Exception.Message)")
        $script:Out.Add(''); $script:Out.Add("오류: $($_.Exception.Message)"); $script:Out.Add("$($_.ScriptStackTrace)")
        try { $f = Write-Report "$($RunMode.ToLower())" '실행 결과 (오류로 멈춤)'; Write-Host "보고서: $f" } catch {}
    } finally {
        if ($tr) { try { Stop-Transcript | Out-Null } catch {} }
    }
    return [bool]($script:ApplyDone -or $script:UndoDone -or $script:BgEditDone)
}

# 적용·되돌리기 뒤 다시 시작 물어보기. 지금 재시작이 어려우면 탐색기만 새로고침해서 일부 변화를 바로 보여줌
function Request-Restart {
    if (Ask "`n지금 다시 시작할까요?") { Restart-Computer -Force; return $true }
    Write-Host '  나중에 직접 다시 시작하세요. (다시 시작해야 모두 적용돼요)' -ForegroundColor Yellow
    if (Ask '  지금 다시 시작이 어려우면, 탐색기만 새로고침해서 작업 표시줄·우클릭 메뉴 변화를 바로 볼까요? (열려 있는 폴더 창이 잠깐 닫혀요)') {
        try { Stop-Process -Name explorer -Force -ErrorAction Stop; Write-Host '  탐색기를 새로고침했어요. (서비스 묶기·빠른 시작·구성요소 제거는 다시 시작해야 적용돼요)' -ForegroundColor Green }
        catch { Write-Host "  탐색기 새로고침 실패 (다시 시작하면 적용돼요): $($_.Exception.Message)" -ForegroundColor Yellow }
    }
    return $false
}

# 하나의 메뉴 창에서 이어서 돌림
function Show-Menu {
    while ($true) {
        Write-Host ''
        Write-Host '============================================================' -ForegroundColor Cyan
        Write-Host '  BeSffy  -  Best SFF Optimizer' -ForegroundColor Cyan
        Write-Host '  이 PC 에 적용 / 점검 / 되돌리기' -ForegroundColor Cyan
        Write-Host "  $Credit  ·  MIT License" -ForegroundColor DarkGray
        Write-Host '============================================================' -ForegroundColor Cyan
        Write-Host '  1. 미리보기         - 무엇을 적용할지 고르고, 바뀔 내용만 봄 (아무것도 안 바꿈)'
        Write-Host '  2. 적용             - 복원 지점·백업을 만든 뒤 고른 대로 적용'
        Write-Host '  3. 점검             - 적용한 것이 지금도 맞는지 확인 (아무것도 안 바꿈)'
        Write-Host '  4. 되돌리기         - 적용했던 것을 되돌림'
        Write-Host '  5. 일부 옵션만 복구 - 막힌 백그라운드 앱, 검색 색인, 꺼 둔 시작 프로그램만 골라서 다시 켬'
        Write-Host '  q. 종료'
        Write-Host ''
        $c = (Read-Host '  번호를 고르세요 (종료는 q)').Trim()
        switch -Regex ($c) {
            '^1$'      { [void](Invoke-One 'Preview') }
            '^2$'      { if (Invoke-One 'Apply') { if (Request-Restart) { return } } }
            '^3$'      { [void](Invoke-One 'Check') }
            '^4$'      { if (Invoke-One 'Undo')  { if (Request-Restart) { return } } }
            '^5$'      { if (Invoke-One 'Restore') { if (Ask "`n지금 다시 시작할까요? (다시 시작해야 확실히 적용돼요)") { Restart-Computer -Force; return } } }
            '^[Qq]$'   { return }
            '^$'       { }
            default    { Write-Host "  '$c' 는 없는 선택이에요. 1~5 또는 q 를 누르세요." -ForegroundColor Yellow }
        }
        if ($c -match '^[1-5]$') { Write-Host ''; [void](Read-Host '  Enter 를 누르면 메뉴로 돌아가요') }
    }
}

# $Here 폴더에 쓸 수 있는지 가볍게 확인 (읽기 전용·압축 안 실행 방지)
function Test-HereWritable {
    try {
        $probe = Join-Path $Here ('.besffy_write_test_' + [IO.Path]::GetRandomFileName())
        [IO.File]::WriteAllText($probe, 'x'); Remove-Item -LiteralPath $probe -Force -ErrorAction SilentlyContinue
        return $true
    } catch { return $false }
}

function Start-Main([string]$RunMode) {
    try { $Host.UI.RawUI.WindowTitle = 'BeSffy - Best SFF Optimizer' } catch {}
    # 단일 .cmd 가 창을 강제로 닫혀 지우지 못한, 하루 지난 임시 스크립트 찌꺼기 정리
    try {
        Get-ChildItem -LiteralPath $env:TEMP -Filter 'BeSffy_*.ps1' -File -ErrorAction SilentlyContinue |
            Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-1) -and $_.FullName -ne $PSCommandPath } |
            Remove-Item -Force -ErrorAction SilentlyContinue
    } catch {}
    Initialize-Paths
    # 읽기 전용 폴더(USB·CD)나 압축 파일 안에서 바로 실행하면 보고서·백업을 못 써서 중간에 멈춰요. 미리 막음
    if (-not (Test-HereWritable)) {
        Write-Host "`n이 폴더에 파일을 쓸 수 없어요: $Here" -ForegroundColor Red
        Write-Host '  압축이라면 먼저 풀고, 바탕화면·문서 같은 쓰기 가능한 일반 폴더로 옮겨서 실행하세요.' -ForegroundColor Yellow
        [void](Read-Host '  Enter 를 누르면 닫혀요'); return
    }
    $tmp = [IO.Path]::GetTempPath().TrimEnd('\')
    if (-not $LiteOnlineNoMain -and $Here.TrimEnd('\') -like "$tmp*") {
        Write-Host "`n임시 폴더에서 실행되고 있어요 ($Here)." -ForegroundColor Yellow
        Write-Host '  압축 파일 안에서 바로 연 것 같아요. 그러면 백업·기록이 임시 폴더에 생겨 나중에 사라질 수 있어요.' -ForegroundColor Yellow
        if (-not (Ask '  그래도 계속할까요?')) { return }
    }
    New-Item -ItemType Directory -Force -Path $script:ReportDir, $script:BackupRoot | Out-Null
    if ($RunMode -eq 'Menu') { Show-Menu; return }
    # 예전처럼 모드를 바로 준 경우 (1_Preview.cmd 등) 한 번만 돌리고 적용·되돌리기면 다시 시작 물어봄
    if (Invoke-One $RunMode) {
        if ($RunMode -in 'Background', 'Restore') { if (Ask "`n지금 다시 시작할까요? (다시 시작해야 확실히 적용돼요)") { Restart-Computer -Force } }
        else { [void](Request-Restart) }
    }
}

if ($LiteOnlineNoMain) { return }   # 모의 실행(시험)에서 함수만 불러올 때
if ($PSVersionTable.PSEdition -eq 'Core') {
    # 앱·구성요소·복원 지점 기능은 Windows PowerShell 5.1 에만 있음
    Write-Host 'PowerShell 7 에서 열렸어요. Windows PowerShell 5.1 로 다시 여는 중...'
    $ps = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
    # -Wait: 새 창(5.1)이 끝날 때까지 기다림. (단일 .cmd 로 돌 때, 새 창이 임시 스크립트를 읽기 전에 .cmd 가 그 파일을 지우는 걸 막음)
    Start-Process -FilePath $ps -Wait -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`" -Mode $Mode"
    return
}
# 32비트 PowerShell 로 열리면 (32비트 프로그램에서 실행한 경우) 레지스트리·시스템 폴더가 32비트용으로 바뀌어 엉뚱한 곳에 적용됨
# → 64비트 PowerShell 로 같은 창에서 다시 실행
if ([Environment]::Is64BitOperatingSystem -and -not [Environment]::Is64BitProcess) {
    $ps = Join-Path $env:SystemRoot 'Sysnative\WindowsPowerShell\v1.0\powershell.exe'
    if (Test-Path -LiteralPath $ps) {
        Write-Host '32비트 PowerShell 로 열렸어요. 64비트로 다시 여는 중...'
        & $ps -NoProfile -ExecutionPolicy Bypass -File $PSCommandPath -Mode $Mode
        return
    }
    Write-Host '32비트 PowerShell 로 열렸는데 64비트 PowerShell 을 찾지 못했어요. 시작 메뉴에서 Windows PowerShell 을 관리자 권한으로 열어 실행해 주세요.' -ForegroundColor Red
    [void](Read-Host 'Enter 를 누르면 닫혀요'); return
}
Start-Main $Mode
