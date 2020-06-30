REM win10 搜索 用户账户控制设置   调成从不通知
Set Shell = CreateObject("Shell.Application")
Shell.ShellExecute "cmd", "/c C:\Users\L\Desktop\reconnect.bat", , "runas", 0