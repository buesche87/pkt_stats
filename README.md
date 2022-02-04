# pkt_stats

Copy this script on your pkt miners, have an influxdb server ready, visualize ond grafana.
Best to use a reverse proxy for influxdb POST.

- change settings in pkt_stats.conf
- copy the cripts you need
  - ```pkt_mining.sh``` - starts packetcrypt_rs with defined parameters in pkt_stats.conf
  - ```pkt_stats.sh``` - monitors output of pkt_mining systemd service
  - ```pkt_chksvc.sh``` - checks if pkt-services are up
  - ```pkt_balance.sh``` - gets balance if pkt-wallet is started as service
  - ```pkt_fold.sh``` - folds your coins once -> prameter needs to be wallet password in clear text, stay safe!
  - ```pkt_cron.sh``` - restarts pkt-services
- change variables in scripts
  - ```TARGETPATH``` - installation-dir
- copy needed systemd service-files to ```/etc/systemd/system```
- change variables in service-files
  - ```PKTUSER``` - linux user
  - ```TARGETPATH``` - installation-dir
- start services
  - ```systemctl enable pkt_*```
  - ```systemctl start pkt_*```

![pkt_stats](https://user-images.githubusercontent.com/11134705/152444501-d0a2280e-8f9f-48c7-9617-841ebb62ef2f.jpg)

Note: You'll need to build your own Grafana dashboard or contact me @ https://t.me/pkt_cash for a template

If you'd like to support me hodl ;) ```pkt1qczhxgwcf6x7qccnmgvy88xfq6shqfx888ggdcl```
