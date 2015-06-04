set wget_path="C:\Program Files\GnuWin32\bin\wget.exe"
set down_dir=D:\Wget
rem set log_dir=Logs

%wget_path% -i %1 -P %down_dir%\Download -c --limit-rate=20k -a %down_dir%\Logs\log.txt