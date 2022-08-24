#!/bin/bash

# Webhook config
WEBHOOK_URL="https://discordapp.com/api/webhooks/mywebhook"
SERVER_NAME="MyServer"
usr="System Alerts"

# Threshold config
memthreshold=70
cputhreshold=90
diskthreshold=70

# Other config
# Total system memory in mb
totalmem=3931

# Request header - do not modify
hdr="Content-Type: application/json"

# CPU load check
cpucores=$(grep -c ^processor /proc/cpuinfo)
cpuload15=$(cat /proc/loadavg | cut -d" " -f3)
cpupct=$(bc <<<"scale=2;($cpuload15/$cpucores*100)/1")

if [ "${cpupct::-3}" -gt "$cputhreshold" ]
then
  curl -H "$hdr" -d '{"username": "'"$usr"'", "embeds":[{"title": "CPU Alert for '"$SERVER_NAME"' server!", "description": "CPU usage exceeded threshold of '"$cputhreshold"'%, currently at '"${cpupct::-3}"'%"}]}' $WEBHOOK_URL
fi

# Memory usage check
freemem=$(($(free -m |awk 'NR==2 {print $3}') * 100))
memusage=$(($freemem / $totalmem))

if [ "$memusage" -gt "$memthreshold" ]
then
  curl -H "$hdr" -d '{"username": "'"$usr"'", "embeds":[{"title": "Memory Alert for '"$SERVER_NAME"' server!", "description": "Memory usage exceeded threshold of '"$memthreshold"'%, currently at '"$memusage"'%"}]}' $WEBHOOK_URL
fi

# Disk usage check
diskusage=$(df --output=pcent / | tr -dc '0-9')

if [ "$diskusage" -gt "$diskthreshold" ]
then
  curl -H "$hdr" -d '{"username": "'"$usr"'", "embeds":[{"title": "Memory Alert for '"$SERVER_NAME"' server!", "description": "Disk usage exceeded threshold of '"$diskthreshold"'%, currently at '"$diskusage"'%"}]}' $WEBHOOK_URL
fi

