# pkt_stats

Copy these scripts to your pkt miners, have an influxdb server ready, visualize your mining data with grafana.
For security use a reverse proxy to POST data into influxdb and access grafana from wan.

---

- Change settings in ```pkt_stats.conf```
- Copy ```pkt_stats.conf``` and the scripts you need to your miner
  - ```pkt_mining.sh``` - starts packetcrypt_rs with defined parameters in ```pkt_stats.conf```
  - ```pkt_stats.sh``` - monitors output of pkt_mining systemd service
  - ```pkt_chksvc.sh``` - checks if pkt-services are up
  - ```pkt_balance.sh``` - gets balance if pkt-wallet is started as service
  - ```pkt_fold.sh``` - folds your coins once -> prameter needs to be wallet password in clear text, stay safe!
  - ```pkt_cron.sh``` - restarts pkt-services
- Copy needed systemd servicefiles to ```/etc/systemd/system```
- Change variables in servicefiles
  - ```PKTUSER``` - linux user running the script
  - ```TARGETPATH``` - path where the scripts are located
- Start services
  - ```systemctl enable pkt_*```
  - ```systemctl start pkt_*```

---

![pkt_stats](https://user-images.githubusercontent.com/11134705/152444501-d0a2280e-8f9f-48c7-9617-841ebb62ef2f.jpg)

Note: You'll need to build your own grafana dashboard or contact me @ https://t.me/pkt_cash for a template

---

If you find this usefull you can support me @ ```pkt1qczhxgwcf6x7qccnmgvy88xfq6shqfx888ggdcl```

![pkt](https://user-images.githubusercontent.com/11134705/187072440-d53a42df-25ca-44ad-a77b-57070b0463b6.png)
