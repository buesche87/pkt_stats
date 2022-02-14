#!/bin/bash
#/////////////////////////////////////////////////////////////////////////////////////
# PKT Folding
#/////////////////////////////////////////////////////////////////////////////////////

# load settings
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/pkt_stats.conf

$installdir/pktd/bin/pktctl  --wallet walletpassphrase $1 60
$installdir/pktd/bin/pktctl  --wallet sendfrom $mining_wallet 0 '["'$mining_wallet'"]'
