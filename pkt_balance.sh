#!/bin/bash
#/////////////////////////////////////////////////////////////////////////////////////
# PKT wallet balance
#/////////////////////////////////////////////////////////////////////////////////////

# load settings
. [TARGET]/pkt_stats.conf

last_balance="$($installdir/pktd/bin/pktctl --wallet getbalance)"

# service mode
while sleep 120; do

	curr_balance="$($installdir/pktd/bin/pktctl --wallet getbalance)"

	curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic' '$balance_sensor'='$curr_balance

	echo "Curr: $curr_balance / Last: $last_balance"

	# check if wallet service running
	if (sudo systemctl is-active pkt_wallet) && (( $(echo "$curr_balance != $last_balance" | bc -l))); then

		curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic' '$wallet_sensor'=1'
		last_balance="$curr_balance"

	# wallet not running
	elif (! sudo systemctl is-active pkt_wallet); then

		curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic' '$wallet_sensor'=0'  

	# balance not changed
	elif (( $(echo "$curr_balance == $last_balance" | bc -l) )); then

		curl -i -XPOST 'http://'$Server':8086/write?db='$Database --data-binary $Topic' '$wallet_sensor'=-1'

	fi

done
