#!/bin/bash
#/////////////////////////////////////////////////////////////////////////////////////
# PKT mining stats
#/////////////////////////////////////////////////////////////////////////////////////

# load settings
. /home/pkt/pkt_stats.conf

# get current mining pools
systemd_line="$(systemctl status pkt_mining | grep 'packetcrypt ann') "
systemd_str="$(echo "$systemd_line" | grep -oP '(?<=http://).*?(?= )' )"
systemd_array=( $systemd_str )

# service mode
journalctl -u pkt_mining.service -f | 
	grep -E --line-buffered "goodrate" | 
		while read line; do
			
			# read mining stats
			encryptions="$(echo $line | awk 'match($0,"e/s"){print substr($0,RSTART-6,6); system("")}' )" 
			bandwith="$(echo $line | awk 'match($0,"b/s"){print substr($0,RSTART-7,7); system("")}' )" 
			
			# get only float numbers
			enc_value="${encryptions//[!0-9.]/}"
			bw_value="${bandwith//[!0-9.]/}"
			
			# post to influxdb
			curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic' '$enc_sensor'='$enc_value
			curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic' '$bw_sensor'='$bw_value

			# API v2 with authentication
			# curl -i -XPOST 'http://'$Server':8086/api/v2/write?bucket='$Database'/rp&precision=ns' \
			#  --header 'Authorization: Token '$Username':'$Password' \	
			#  --data-raw $Topic','$enc_sensor'='$enc_value'

			# curl -i -XPOST 'http://'$Server':8086/api/v2/write?bucket='$Database'/rp&precision=ns' \
			#  --header 'Authorization: Token '$Username':'$Password' \	
			#  --data-raw $Topic','$bw_sensor'='$bw_value'
	
			# get goodrate
			i=0
			str_goodrate="$(echo "$line" | grep -oP '(?<=goodrate: \[).*?(?=\])' )"
			gr_value="${str_goodrate//[!0-9,]/}"
			IFS=',' read -r -a gr_array <<< "$gr_value"
			
			# assign goodrate to pool and post to influxdb
			for element in "${gr_array[@]}"
			do
				pool="${systemd_array[i]}"
				gr_value=$element
				
				curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic',Pool='$pool' '$gr_sensor'='$gr_value

				# curl -i -XPOST 'http://'$Server':8086/api/v2/write?bucket='$Database'/rp&precision=ns' \
				#  --header 'Authorization: Token '$Username':'$Password' \	
				#  --data-raw $Topic','$bw_sensor'='$bw_value'
				
				i=$((i+1))

			done
			
		done
