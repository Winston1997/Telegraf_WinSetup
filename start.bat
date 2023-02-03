echo off
cls
echo.
echo.
echo "    ______            _       __        "
echo "   / ____/___  ____  (_)___  / /_       "
echo "  / __/ / __ \/ __ \/ / __ \/ __/       "
echo " / /___/ /_/ / /_/ / / / / / /_         "
echo "/_____/ .___/\____/_/_/ /_/\__/         "
echo "    _/_/        __        ____          "
echo "   /   | __  __/ /_____  /  _/___  _____"
echo "  / /| |/ / / / __/ __ \ / // __ \/ ___/"
echo " / ___ / /_/ / /_/ /_/ // // / / (__  ) "
echo "/_/  |_\__,_/\__/\____/___/_/ /_/____/  "

unzip -d %cd% telegraf.zip

rem 自动获取ip
echo 正在获取本机ip...
for /f "tokens=16" %%i in ('ipconfig ^|find /i "ipv4"') do set ip=%%i
echo 获取成功，ip=%ip%
echo 正在重置配置文件...
echo 请输入influxdb所在服务器IP地址：
set /p abc=

echo [global_tags] >telegraf.conf
echo.>>telegraf.conf
echo [agent] >>telegraf.conf
echo  interval = "10s" >>telegraf.conf
echo  round_interval = true >>telegraf.conf
echo  metric_batch_size = 1000 >>telegraf.conf
echo  metric_buffer_limit = 10000 >>telegraf.conf
echo  collection_jitter = "0s" >>telegraf.conf
echo  flush_interval = "10s" >>telegraf.conf
echo  flush_jitter = "0s" >>telegraf.conf
echo  precision = "0s" >>telegraf.conf
echo  hostname = "%ip%" >>telegraf.conf
echo  omit_hostname = false >>telegraf.conf
echo.>>telegraf.conf
echo [[outputs.influxdb]] >>telegraf.conf
echo   urls = ["http://%abc%:8086"] >>telegraf.conf
echo   database = "telegraf" >>telegraf.conf
echo   retention_policy = "" >>telegraf.conf
echo   username = "admin" >>telegraf.conf
echo   password = "11111" >>telegraf.conf
echo.>>telegraf.conf
echo [[inputs.cpu]] >>telegraf.conf
echo  percpu = true >>telegraf.conf
echo  totalcpu = true >>telegraf.conf
echo  collect_cpu_time = false >>telegraf.conf
echo  report_active = false >>telegraf.conf
echo  core_tags = false >>telegraf.conf
echo.>>telegraf.conf
echo [[inputs.disk]] >>telegraf.conf
echo  ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"] >>telegraf.conf
echo.>>telegraf.conf
echo [[inputs.mem]] >>telegraf.conf
echo.>>telegraf.conf
echo [[inputs.system]] >>telegraf.conf
echo.>>telegraf.conf
echo    [[inputs.win_perf_counters.object]] >>telegraf.conf
echo      ObjectName = "LogicalDisk" >>telegraf.conf
echo      Instances = ["*"] >>telegraf.conf
echo      Counters = [ >>telegraf.conf
echo       "%% Idle Time", >>telegraf.conf
echo      ] >>telegraf.conf
echo      Measurement = "win_disk" >>telegraf.conf
echo.>>telegraf.conf
echo   [[inputs.win_perf_counters.object]] >>telegraf.conf
echo     ObjectName = "PhysicalDisk" >>telegraf.conf
echo     Instances = ["*"] >>telegraf.conf
echo     Counters = [ >>telegraf.conf
echo       "Disk Read Bytes/sec", >>telegraf.conf
echo       "Disk Write Bytes/sec", >>telegraf.conf
echo       "Disk Reads/sec", >>telegraf.conf
echo       "Disk Writes/sec", >>telegraf.conf
echo     ] >>telegraf.conf
echo     Measurement = "win_diskio" >>telegraf.conf
echo.>>telegraf.conf
echo  [[inputs.win_perf_counters.object]] >>telegraf.conf
echo     ObjectName = "Network Interface" >>telegraf.conf
echo     Instances = ["*"] >>telegraf.conf
echo    Counters = [ >>telegraf.conf
echo       "Bytes Received/sec", >>telegraf.conf
echo       "Bytes Sent/sec", >>telegraf.conf
echo     ] >>telegraf.conf
echo     Measurement = "win_net" >>telegraf.conf

echo 正在创建telegraf服务...
md "C:\Program Files\Telegraf"
copy telegraf.conf "C:\Program Files\Telegraf\"
telegraf.exe --service install 
telegraf.exe --service start
echo Telegraf监控服务启动成功!
timeout /T 5
exit