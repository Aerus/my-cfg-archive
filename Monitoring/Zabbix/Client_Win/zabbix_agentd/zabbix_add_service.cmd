sc create "Zabbix Agent" binPath= "\"C:\zabbix_agentd.exe\" --config \"C:\zabbix_agentd.conf\"" DisplayName= "Zabbix Agent" type= own start= auto 
net start "Zabbix Agent"
pause

