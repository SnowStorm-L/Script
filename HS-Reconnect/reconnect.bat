@echo off

REM ����ǽ��������(���Զ���)
set ruleName=¯ʯ����
REM �����ӳ�ʱ����(�ж϶�����֮�ڵ���־Ϊ����)
set checkTime=40
REM ����ʱ��(�ڼ䰴���������ֱ�ӻָ�����Ȩ��)
set timeOut=5
REM ��������(һ�������޸�)
set softName=Hearthstone.exe

REM ��ȡ¯ʯ���̺�·��
for /f "delims=" %%i in ('wmic Process where "Name='%softName%'" get ExecutablePath^|find ":"') do (
  set "LSexe=%%~ftzai"
  set "LSdir=%%~dpi"
)

REM �ж�¯ʯ�Ƿ�������
if "%LSexe%"=="" (
  echo �޷���ȡ[¯ʯ��˵]·���������˳�...
  TIMEOUT /T 3
  exit
)

REM ȥ���Ҳ�ո�
set TrimLSexe=%LSexe%
set TrimLSdir=%LSdir%
:righttrim
if "%TrimLSexe:~-1%"==" " set "TrimLSexe=%TrimLSexe:~0,-1%"&goto righttrim
if "%TrimLSdir:~-1%"==" " set "TrimLSdir=%TrimLSdir:~0,-1%"&goto righttrim
set LogFile=%TrimLSdir%Logs\Power.log

REM �����Ȼ��������ӳ�����
setlocal enabledelayedexpansion

REM ��ȡ�ļ��޸�����
for %%a in ("%LogFile%") do (
  set fileTmp=%%~ta
  set fileUpdDate=!fileTmp:~0,10!
)

REM ��ȡϵͳʱ��
set systime=%time:~0,-3%
set sysdate=%date:~0,10%
set sysHH=%time:~0,2%
if %time:~3,1% == 0 (
  set sysMI=%time:~4,1%
) else (
  set sysMI=%time:~3,2%
)
if %time:~6,1% == 0 (
  set sysSS=%time:~7,1%
) else (
  set sysSS=%time:~6,2%
)
set /a sysTimeCal=%sysHH%*3600+%sysMI%*60+%sysSS%

REM ��ȡ���������
set yyyy=%date:~0,4%
set mm=%date:~5,2%
set dd=%date:~8,2%
set /a nd=!dd!-1
if !nd!==0 call :dd0
if !mm!==0 call :mm0
set yyyymmdd=!yyyy!/!mm!/!nd!
set yesterday=!yyyymmdd!
goto checkdate

:dd0
set /a mm=!mm!-1
for %%a in (1 3 5 7 8 10 12)do set %%add=31
set /a pddd=!yyyy!*10/4
set pd2d=!pddd:~-1,1!
set 2dd=28
if !pd2d!==0 set 2dd=29
for %%b in (4 6 9 11)do set %%bdd=30
set nd=!%mm%dd!
goto :eof
:mm0
set /a yyyy=!yyyy!-1
set mm=12
set nd=31
goto :eof

REM �ж��Ƿ�Ϊ���������
:checkdate
echo ��־�ļ���%LogFile%
echo �޸����ڣ�%fileUpdDate%
echo ϵͳ���ڣ�%sysdate%
echo zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
if %fileUpdDate%==%sysdate% (
  echo �ļ��޸�����Ϊ���죬�������������
  goto cmp1
) else if %fileUpdDate%==%yesterday% (
  echo �ļ��޸�ʱ��Ϊ���죬�������������
  goto cmp1
) else (
  echo �ļ��޸�ʱ�����������������
  goto duanxian
)

REM ��ȡ�ļ���������־��ʱ��
:cmp1
for /F "tokens=1 delims=D. " %%i in ('findstr "FINAL_GAMEOVER" "%LogFile%"') do (
  set deadtime=%%~i
)

REM �������������¼��������жϣ�����ֱ�ӽ��ж���
if "%deadtime%" == "" (
  echo δ������ָ����������¼
  goto duanxian
) else (
  goto liveOrDie
)

:liveOrDie
REM ��һλΪ0ʱĬ��ʶ��8���ƣ���Ҫȥ��
set deadHH=%deadtime:~0,2%
if %deadtime:~3,1% == 0 (
  set deadMI=%deadtime:~4,1%
) else (
  set deadMI=%deadtime:~3,2%
)
if %deadtime:~6,1% == 0 (
  set deadSS=%deadtime:~7,1%
) else (
  set deadSS=%deadtime:~6,2%
)
set /a deadCal=%deadHH%*3600+%deadMI%*60+%deadSS%

REM �����ϵͳʱ��Ĳ��� difftimeĿǰ��ȥ����ʱ�䣬difftime1Ϊ����ʱ��һ��ʱ��
set /a difftime=%sysTimeCal%-%deadCal%
set /a difftime1=%difftime%+86400
echo zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
if %difftime% GEQ 0 (
  if %difftime% LEQ %checkTime% (
    echo [��������][��������][��������]
    echo [��������][��������][��������]
    echo [��������][��������][��������]
    goto anyButtom
  ) else (
    echo δ������ָ����������¼
    goto duanxian
  )
) else if %difftime1% LEQ %checkTime% (
  echo [��������][��������][��������]
  echo [��������][��������][��������]
  echo [��������][��������][��������]
  goto anyButtom
) else (
  echo δ������ָ����������¼
  goto duanxian
)

:anyButtom
echo zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
choice /n /t 5 /d n /m �Ƿ�Ҫ��������[Y]���Զ��˳�[N]
if errorlevel 2 (
  REM Ĭ��N��ֱ���˳�
  exit
)
if errorlevel 1 (
  REM Y��������
  goto duanxian
)

:duanxian
echo zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
echo [��ʼ����]
REM ��������ڹ������������¯ʯ����Ȩ�޵Ĺ��򣬷���������һ��
netsh advfirewall firewall show rule name="%ruleName%" >nul
if %errorlevel% == 0 (
  echo ����ǽ���� "%ruleName%" �Ѿ�����
)else (
  netsh advfirewall firewall add rule name="%ruleName%" dir=out program="%TrimLSexe%" action=block >nul
  if %errorlevel% == 0 (
    echo ����ǽ���� "%ruleName%" ��ӳɹ�
  )else (
    echo ��ӷ���ǽ����ʧ�ܣ������Ƿ�߱�[����ԱȨ��]�������˳�...
    TIMEOUT /T 5
    exit
  )
)

REM ����¯ʯ����·����������ָ������ (��ֹ¯ʯ��������)
netsh advfirewall firewall set rule name="%ruleName%" new program="%TrimLSexe%" enable=yes >nul
if %errorlevel% == 0 (
  echo ¯ʯ��������Ч���ȴ��ָ���...
)else (
  echo ����ǽ�����޸�ʧ�ܣ������Ƿ�߱�[����ԱȨ��]�������˳�...
  TIMEOUT /T 5
  exit
)

REM �ȴ�һ��ʱ�䣬���������������
echo zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
echo [������][������][������]
echo [������][������][������]
echo [������][������][������]
echo zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
echo ��������������ָ�����Ȩ��
TIMEOUT /T %timeOut%

REM ����ָ������ (����¯ʯ��������)
netsh advfirewall firewall set rule name="%ruleName%" new enable=no >nul
if %errorlevel% == 0 (
  echo �ָ�¯ʯ����ɹ�
  exit
)else (
  echo ����ǽ����ָ�ʧ�ܣ������Ƿ�߱�[����ԱȨ��]����������˳�...
  pause
  exit
)
