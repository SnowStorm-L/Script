@echo off

REM 防火墙规则名称(可自定义)
set ruleName=炉石断线
REM 死亡延迟时间检测(判断多少秒之内的日志为死亡)
set checkTime=40
REM 断线时间(期间按任意键可以直接恢复网络权限)
set timeOut=5
REM 进程名称(一般无需修改)
set softName=Hearthstone.exe

REM 获取炉石进程和路径
for /f "delims=" %%i in ('wmic Process where "Name='%softName%'" get ExecutablePath^|find ":"') do (
  set "LSexe=%%~ftzai"
  set "LSdir=%%~dpi"
)

REM 判断炉石是否已启动
if "%LSexe%"=="" (
  echo 无法获取[炉石传说]路径，即将退出...
  TIMEOUT /T 3
  exit
)

REM 去除右侧空格
set TrimLSexe=%LSexe%
set TrimLSdir=%LSdir%
:righttrim
if "%TrimLSexe:~-1%"==" " set "TrimLSexe=%TrimLSexe:~0,-1%"&goto righttrim
if "%TrimLSdir:~-1%"==" " set "TrimLSdir=%TrimLSdir:~0,-1%"&goto righttrim
set LogFile=%TrimLSdir%Logs\Power.log

REM 开启度环境变量延迟命令
setlocal enabledelayedexpansion

REM 获取文件修改日期
for %%a in ("%LogFile%") do (
  set fileTmp=%%~ta
  set fileUpdDate=!fileTmp:~0,10!
)

REM 获取系统时间
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

REM 获取昨天的日期
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

REM 判断是否为今天和昨天
:checkdate
echo 日志文件：%LogFile%
echo 修改日期：%fileUpdDate%
echo 系统日期：%sysdate%
echo zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
if %fileUpdDate%==%sysdate% (
  echo 文件修改日期为当天，将进行死亡检测
  goto cmp1
) else if %fileUpdDate%==%yesterday% (
  echo 文件修改时间为昨天，将进行死亡检测
  goto cmp1
) else (
  echo 文件修改时间差异大，跳过死亡检测
  goto duanxian
)

REM 获取文件中死亡日志的时间
:cmp1
for /F "tokens=1 delims=D. " %%i in ('findstr "FINAL_GAMEOVER" "%LogFile%"') do (
  set deadtime=%%~i
)

REM 如果存在死亡记录，则继续判断，否则直接进行断线
if "%deadtime%" == "" (
  echo 未搜索到指定的死亡记录
  goto duanxian
) else (
  goto liveOrDie
)

:liveOrDie
REM 第一位为0时默认识别8进制，需要去除
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

REM 计算和系统时间的差异 difftime目前减去死亡时间，difftime1为负数时加一天时间
set /a difftime=%sysTimeCal%-%deadCal%
set /a difftime1=%difftime%+86400
echo zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
if %difftime% GEQ 0 (
  if %difftime% LEQ %checkTime% (
    echo [你已死亡][你已死亡][你已死亡]
    echo [你已死亡][你已死亡][你已死亡]
    echo [你已死亡][你已死亡][你已死亡]
    goto anyButtom
  ) else (
    echo 未搜索到指定的死亡记录
    goto duanxian
  )
) else if %difftime1% LEQ %checkTime% (
  echo [你已死亡][你已死亡][你已死亡]
  echo [你已死亡][你已死亡][你已死亡]
  echo [你已死亡][你已死亡][你已死亡]
  goto anyButtom
) else (
  echo 未搜索到指定的死亡记录
  goto duanxian
)

:anyButtom
echo zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
choice /n /t 5 /d n /m 是否要继续断线[Y]或自动退出[N]
if errorlevel 2 (
  REM 默认N，直接退出
  exit
)
if errorlevel 1 (
  REM Y继续断线
  goto duanxian
)

:duanxian
echo zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
echo [开始断线]
REM 如果不存在规则，则添加屏蔽炉石网络权限的规则，否则跳过这一步
netsh advfirewall firewall show rule name="%ruleName%" >nul
if %errorlevel% == 0 (
  echo 防火墙规则 "%ruleName%" 已经存在
)else (
  netsh advfirewall firewall add rule name="%ruleName%" dir=out program="%TrimLSexe%" action=block >nul
  if %errorlevel% == 0 (
    echo 防火墙规则 "%ruleName%" 添加成功
  )else (
    echo 添加防火墙规则失败，请检查是否具备[管理员权限]，即将退出...
    TIMEOUT /T 5
    exit
  )
)

REM 更新炉石程序路径，并启用指定规则 (禁止炉石访问网络)
netsh advfirewall firewall set rule name="%ruleName%" new program="%TrimLSexe%" enable=yes >nul
if %errorlevel% == 0 (
  echo 炉石断网已生效，等待恢复中...
)else (
  echo 防火墙规则修改失败，请检查是否具备[管理员权限]，即将退出...
  TIMEOUT /T 5
  exit
)

REM 等待一段时间，按任意键可以跳过
echo zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
echo [断网中][断网中][断网中]
echo [断网中][断网中][断网中]
echo [断网中][断网中][断网中]
echo zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
echo 按任意键可立即恢复网络权限
TIMEOUT /T %timeOut%

REM 禁用指定规则 (允许炉石访问网络)
netsh advfirewall firewall set rule name="%ruleName%" new enable=no >nul
if %errorlevel% == 0 (
  echo 恢复炉石网络成功
  exit
)else (
  echo 防火墙规则恢复失败，请检查是否具备[管理员权限]，按任意键退出...
  pause
  exit
)
