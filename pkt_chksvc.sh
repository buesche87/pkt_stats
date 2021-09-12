#!/bin/bash
#/////////////////////////////////////////////////////////////////////////////////////
# PKT check services
#/////////////////////////////////////////////////////////////////////////////////////

# load settings
. [TARGET]/pkt_stats.conf

# service mode
while sleep 300; do
  
	# check mining
	if (systemctl is-active --quiet pkt_mining); then
	
		curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic' '$mining_sensor'=1'
	
	elif (! systemctl is-active --quiet pkt_mining); then
	
		curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic' '$mining_sensor'=0'
	
	fi

	svc_mining_start="$(systemctl show pkt_mining --property=ActiveEnterTimestamp | cut -d= -f2)"
	svc_stats_start="$(systemctl show pkt_stats --property=ActiveEnterTimestamp | cut -d= -f2)"
	svc_mining_epoch=$(date -d "${svc_mining_start}" +"%s")
	svc_stats_epoch=$(date -d "${svc_mining_start}" +"%s")
 
	# check if stats running
	if (systemctl is-active --quiet pkt_stats) && [ $svc_mining_epoch -le $svc_stats_epoch ]; then

		curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic' '$stats_sensor'=1'

	# check if mining started before stats
	elif [ $svc_mining_epoch -gt $svc_stats_epoch ]; then
	
		curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic' '$stats_sensor'=-1'

	# stats not running
	elif (! systemctl is-active --quiet pkt_stats); then
  
		curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic' '$stats_sensor'=0'
	
	fi
 
done
