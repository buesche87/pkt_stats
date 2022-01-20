#!/bin/bash
#/////////////////////////////////////////////////////////////////////////////////////
# PKT wallet balance
#/////////////////////////////////////////////////////////////////////////////////////

# load settings
. /home/pkt/pkt_stats.conf

# service mode
while sleep 1; do
	
	last_balance="$($installdir/pktd/bin/pktctl --wallet getbalance)"
	sleep 300
	
	walletstat="$(sudo systemctl is-active pkt_wallet)"
	curr_balance="$($installdir/pktd/bin/pktctl --wallet getbalance)"
	delta="$(echo "$curr_balance != $last_balance" | bc -l)"

	curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic' '$balance_sensor'='$curr_balance
	
	echo "Last Balance: $last_balance"
	echo "Current Balance: $curr_balance"
	echo ""
	
	# check if wallet service running
	if [[ "$walletstat" == "active"  ]] && [[ "$delta" == "1" ]]; then

		curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic' '$wallet_sensor'=1'
		last_balance="$curr_balance"

	# wallet not running
	
	elif [[ ! "$walletstat" == "active" ]]; then

		curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic' '$wallet_sensor'=0'  

	# balance not changed
	elif [[ "$delta" == "0" ]]; then

		curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic' '$wallet_sensor'=2'

	fi

done
