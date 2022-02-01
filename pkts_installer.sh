#!/bin/bash
######################################
# pkt_stats installer
######################################

if [ $(id -u) -ne 0 ]; then
  printf "Script must be run as root. Try 'sudo ./pkt_installer.sh'\n"
  exit 1
fi

# Settings
. ./pkt_stats.conf

# Parameters
while getopts ":s:m:w:b:c:f:" opt; do
  case $opt in
    s) inststats=true
    ;;
    m) instminer=true
    ;;
    w) instwallet=true
    ;;
    b) instbalance=true
    ;;
    c) instchksvc=true
    ;;
    f) instfold=true
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# create script
create_script () {
  
  cp ./$1.sh /$installdir/$1.sh
  sed -i "s/TARGETPATH/$installdir/" /$installdir/$1.sh
  chmod +x /$installdir/$1.sh

}

# create service
create_service () {
  
  sed -i "s/TARGETPATH/$installdir/" ./ressources/$1.service
  sed -i "s/PKTUSER/$pkt_user/" ./ressources/$1.service
  cp ./ressources/$1.service /etc/systemd/system/$1.service

  # enable & start services
  systemctl enable $1.service
  systemctl start $1.service

}


# install pkt_miner
install_miner () {

  # install packetcrypt_rs
  git clone https://github.com/cjdelisle/packetcrypt_rs --branch develop $installdir
  cd $installdir/packetcrypt_rs
  ~/.cargo/bin/cargo build --release
  cd -

  create_script pkt_mining
  create_service pkt_mining

}


# install pkt_wallet
install_wallet () {

  # install wallet
  git clone https://github.com/pkt-cash/pktd $installdir
  cd $installdir/pktd
  ./do
  ./bin/pktwallet --create
  ./bin/pktctl --wallet getnewaddress > $installdir/wallet_address
  cd -

  echo "%$pkt_user ALL=NOPASSWD: /bin/systemctl status pkt_wallet" > /etc/sudoers.d/pkt_stats
  echo "%$pkt_user ALL=NOPASSWD: /bin/systemctl is-active pkt_wallet" >> /etc/sudoers.d/pkt_stats

  create_service pkt_wallet

}

# create pkt user
echo $pkt_pass | passwd $pkt_user --stdin
usermod -aG sudo $pkt_user

# create install dir
mkdir -p $installdir
chown $pkt_user:$pkt_user $installdir

# install dependencies
apt install make gcc-multilib git

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install go
wget $golang_tar
sudo tar -C /usr/local -xzf go1.*.tar.gz 
echo "export PATH=$PATH:/usr/local/go/bin" >> /home/$pkt_user/.profile
echo "export GOPATH=~/.go" >> /home/$pkt_user/.profile

# install pkt_stats modules
if $instminer ; then install_miner; fi
if $instwallet ; then install_wallet; fi
if $instfold ; then create_script pkt_fold; fi
if $instbalance ; then create_script pkt_balance; create_service pkt_balance; fi
if $inststats ; then create_script pkt_stats; create_service pkt_stats; fi
if $instchksvc ; then create_script pkt_chksvc; create_service pkt_chksvc; fi


