#!/bin/bash
#/////////////////////////////////////////////////////////////////////////////////////
# PKT check services
#/////////////////////////////////////////////////////////////////////////////////////

# load settings
. TARGETPATH/pkt_stats.conf

# service mode
while sleep 1; do
	
	miningstat="$(sudo systemctl is-active pkt_mining)"
	
	# check mining
	if [[ "$miningstat" == "active"  ]] ; then
	
		curl -i -XPOST $Server'/write?db='$Database --data-binary $Topic' '$mining_sensor'=1'
	
	elif [[ ! "$miningstat" == "active"  ]] ; then
	
		curl -i -XPOST $Server'/write?db='$Database --data-binary $Topic' '$mining_sensor'=0'
	
	fi

	svc_mining_start="$(systemctl show pkt_mining --property=ActiveEnterTimestamp | cut -d= -f2)"
	svc_stats_start="$(systemctl show pkt_stats --property=ActiveEnterTimestamp | cut -d= -f2)"
	svc_mining_epoch=$(date -d "${svc_mining_start}" +"%s")
	svc_stats_epoch=$(date -d "${svc_mining_start}" +"%s")
 
	# check if stats running
	if (systemctl is-active --quiet pkt_stats) && [ $svc_mining_epoch -le $svc_stats_epoch ]; then

		curl -i -XPOST $Server'/write?db='$Database --data-binary $Topic' '$stats_sensor'=1'

	# check if mining started before stats
	elif [ $svc_mining_epoch -gt $svc_stats_epoch ]; then
	
		curl -i -XPOST $Server'/write?db='$Database --data-binary $Topic' '$stats_sensor'=-1'

	# stats not running
	elif (! systemctl is-active --quiet pkt_stats); then
  
		curl -i -XPOST $Server'/write?db='$Database --data-binary $Topic' '$stats_sensor'=0'
	
	fi
	
	sleep 300
 
done
