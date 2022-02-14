#!/bin/bash
#/////////////////////////////////////////////////////////////////////////////////////
# PKT miner
#/////////////////////////////////////////////////////////////////////////////////////

# load settings
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. SCRIPT_DIR/pkt_stats.conf

$installdir/packetcrypt_rs/target/release/packetcrypt ann -T $mining_threads -U $mining_uploader -p $mining_wallet $mining_pools
