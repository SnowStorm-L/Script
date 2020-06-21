;左边的win键 替换为 左边的Ctrl键
LWin::LCtrl

;左边的Ctrl键 替换 左边的Win键
LCtrl::LWin 

;指定程序执行 (ahk 按照目录 有可视化查询 ahk的程序)
#IfWinActive, ahk_exe rider64.exe
LWin::LAlt
#IfWinActive