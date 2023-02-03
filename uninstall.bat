@echo off
echo Stopping services...
net stop telegraf
echo Removing Telegraf...
SC DELETE telegraf
timeout /t 5
exit