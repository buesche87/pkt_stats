# pkt_stats

Install this script on your pkt miners, have a influxdb server with grafana ready for nice visualizations

First change settings in pkt_stats.conf

Then run the pkts_installer.sh with following parameters: (don't use the installer - it's broken)

- s: installs the pkt_stats script
- m: installs packetcrypt_rs miner
- w: installs the pkt cli wallet
- b: installs a service that gets the balance out of your wallet and puts it into influxdb
- c: installs a service that monitors your pkt-services 
- f: installs a script to easily fold your coins

![image](https://user-images.githubusercontent.com/11134705/132981374-de559ac9-3349-4f19-909c-835750447307.png)

