#
#  Vars
#
# HTTP service to monitor (URL)
url=""
# Expected HTTP status code
expected=200
# A directory to store the last check status
workingDir="/tmp/"
# Discord channel webhook URL to send notifications to
webhookUrl=""


#
#  Alert Embeds
#
function downAlert {
  cat << EOF
{
  "embeds": [
    {
      "title": "Service Outage Alert",
      "description": "The following service monitor has failed it's http health check.",
      "color": 16712738,
      "fields": [
        {
          "name": "Service",
          "value": "$1"
        },
        {
          "name": "Expected",
          "value": "$2"
        },
        {
          "name": "Actual",
          "value": "$3"
        }
      ]
    }
  ]
}
EOF
}

function recoveryAlert {
  cat << EOF
{
  "embeds": [
    {
      "title": "Service Recovery Alert",
      "description": "The following service monitor has recovered from an outage.",
      "color": 5553736,
      "fields": [
        {
          "name": "Service",
          "value": "$1"
        },
        {
          "name": "Expected",
          "value": "$2"
        },
        {
          "name": "Actual",
          "value": "$3"
        }
      ]
    }
  ]
}
EOF
}

#
# 1. A function that prints a JSON POST message for Discord
# 2. The Service URL that failed
# 3. The expected result of the check
# 4. The actual result of the check
#
function sendDiscordEmbed {
  curl $webhookUrl --fail --connect-timeout 10 --max-time 10 --show-error --request POST --header "Content-Type: application/json" --data "$($1 $2 $3 $4)"
}

#
#  Main
#
urlFS=${url////} # Remove the '//' from the url so it will work as an FS path

# Read in the last exec result
if [ -f $workingDir$urlFS.stat ]; then
  last=$(cat $workingDir$urlFS.stat)
fi

# Ping the target & save the result
status=$(curl $url -I -s | head -n 1 | cut '-d ' '-f2')
if [ -z "$status" ]; then
  status="Timeout"
fi
echo $status > $workingDir$urlFS.stat

# Send a down alert the first time we see the target down
if [ "$status" != $expected ] && [ "$last" != "$status" ]; then
  sendDiscordEmbed downAlert $url $expected "$status"
fi

# Send a recovery alert the first time we see the target up
if [ "$status" = $expected ] && [ "$last" != $expected ]; then
  sendDiscordEmbed recoveryAlert $url $expected "$status"
fi
