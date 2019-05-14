#!/bin/bash
# AttackDeployAttackTools Only - 0.1
# ZephrFish
# Script for deploying new VPS & downloading all required tools
# This version takes away the SSL setup & OS hardening
# Note: This is a work in progress :-)

# Root Check
if [ `whoami` != root ]; then
    echo "This script must be run as root"
    exit 1
fi

# Install Basic Repos
 rm -rf /etc/apt/sources.list
 touch /etc/apt/sources.list
 echo "# Debian 9" >> /etc/apt/sources.list
 echo "deb http://ftp.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list
 echo "deb-src http://ftp.debian.org/debian testing main contrib non-free" >> /etc/apt/sources.list
 echo "deb http://ftp.debian.org/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list
 echo "deb-src http://ftp.debian.org/debian/ stretch-updates main contrib non-free" >> /etc/apt/sources.list
 echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list

# Install Kali Repos
 apt-key adv --keyserver pgp.mit.edu --recv-keys ED444FF07D8D0BF6
 echo "# Kali linux repos" >> /etc/apt/sources.list
 echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" >> /etc/apt/sources.list

# Update & Upgrade Repo
 apt update
 #apt-get upgrade -y
 #apt-get dist-upgrade -y
 apt-get autoclean

# Install Basics
apt install sudo git wget curl git zip ccze byobu zsh golang  ufw python-pip -y python3 python3-pip

# Install Basic Attack Tools
apt-get install -y nikto dotdotpwn jsql nmap sqlmap sqlninja thc-ipv6 hydra metasploit-framework dirb
apt-get -y install build-essential checkinstall fail2ban gcc firefox git sqlite3 ruby ruby-dev git-core python-dev python-pip unzip jruby libbz2-dev libc6-dev libgdbm-dev libncursesw5-dev libreadline-gplv2-dev libsqlite3-dev libssl-dev nikto nmap nodejs python-dev python-numpy python-scipy python-setuptools tk-dev unattended-upgrades wget curl
apt-get install -y xvfb x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic x11-apps clang libdbus-1-dev libgtk2.0-dev libnotify-dev libgnome-keyring-dev libgconf2-dev libasound2-dev libcap-dev libcups2-dev libxtst-dev libxss1 libnss3-dev gcc-multilib g++-multilib libldns-dev

# Install Chrome
echo "[*] Install Chrome.[*]"
wget -N https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P ~/
dpkg -i --force-depends ~/google-chrome-stable_current_amd64.deb
apt-get -f install -y
dpkg -i --force-depends ~/google-chrome-stable_current_amd64.deb

# Javascript frameworks
echo "[*] Install nodejs [*]"
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs

echo "[*] Install PhantomJs[*]"
curl -L https://gist.githubusercontent.com/ManuelTS/935155f423374e950566d05d1448038d/raw/906887cbfa384d450276b87087d28e6a51245811/install_phantomJs.sh | sh

echo "[*] Install Casperjs[*]"
git clone git://github.com/n1k0/casperjs.git
cd casperjs
ln -sf `pwd`/bin/casperjs /usr/local/bin/casperjs
cd ..

# Ruby 
echo "[*] Install Ruby[*]"
apt-get -qq install gnupg2 -y
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -L https://get.rvm.io | bash -s stable --ruby
echo "source /usr/local/rvm/scripts/rvm" >> ~/.bashrc


# Make Tools & Wordlists Directory
echo "[*] making wordlist directories[*]"
mkdir /usr/share/wordlists
mkdir /usr/share/tools
mkdir /usr/share/tools/scripts/

# Pull Wordlists
echo "[*] Pulling Wordlists[*]"
cd /usr/share/wordlists
git clone https://github.com/danielmiessler/SecLists
git clone https://github.com/danielmiessler/RobotsDisallowed
cd SecLists
tar xvzf rockyou.tar.gz

# DNS Tooling
echo "[*] Install DNS tools[*]"
cd /usr/share/tools
mkdir DNS
cd DNS
git clone https://github.com/lorenzog/dns-parallel-prober
git clone https://github.com/aboul3la/Sublist3r
git clone https://github.com/michenriksen/aquatone
git clone https://github.com/guelfoweb/knock
git clone https://github.com/anshumanbh/brutesubs
git clone https://github.com/jhaddix/domain
apt -f install fierce

# expired domain take overs
echo "[*] Install autoSubTakeover[*]"
cd /usr/share/tools
git clone https://github.com/JordyZomer/autoSubTakeover.git
cd autoSubTakeover
pip install -r requirements.txt
cd ..

# sending test payloads for known web CVEs
echo "[*] Install web-cve-tests[*]"
git clone https://github.com/tai-euler/web-cve-tests

# Online Local Vulnerability Scanner
echo "[*] Install Vulmap[*]"
git clone https://github.com/tai-euler/Vulmap

# CMS Tooling
echo "[*] Install CMS tools[*]"
cd /usr/share/tools
mkdir CMS && cd CMS
git clone https://github.com/droope/droopescan
apt install -y wpscan
git clone https://github.com/Dionach/CMSmap

# Directory Busting
echo "[*] Install directory busters[*]"
cd /usr/share/tools
apt install dirb -y
git clone https://github.com/OJ/gobuster
#wget https://github.com/OJ/gobuster/archive/v1.3.tar.gz
#tar xzvf v1.3.tar.gz
#mv gobuster-1.3 go-buster
#cd go-buster
#wget https://gist.github.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/all.txt
#go build
#chmod 777 gobuster
#cd ..
git clone https://github.com/henshin/filebuster
git clone https://github.com/TheRook/subbrute.git
git clone https://github.com/maurosoria/dirsearch.git
wget https://gist.githubusercontent.com/random-robbie/b8fad5cbff2c5dbcb3470b6cd0c6d635/raw/dirsearch_it.sh -O /bin/dirsearch
chmod 777 /bin/dirsearch

# Git Recon
echo "[*] Install git recon tools[*]"
mkdir /usr/share/tools/git
cd /usr/share/tools/git
git clone https://github.com/libcrack/gitrecon
git clone https://github.com/dxa4481/truffleHog
git clone https://github.com/michenriksen/gitrob

# OSINT Tooling
echo "[*] Install Osint tools[*]"
mkdir /usr/share/tools/OSINT
cd /usr/share/tools/OSINT
apt install -y recon-ng
git clone https://github.com/smicallef/spiderfoot
git clone https://github.com/ZephrFish/GoogD0rker
git clone https://github.com/GerbenJavado/LinkFinder

# HTTP Analysis
echo "[*] Install HTTP analysis[*]"
cd /usr/share/tools
git clone https://github.com/ChrisTruncer/EyeWitness
git clone https://github.com/robertdavidgraham/masscan
git clone https://github.com/random-robbie/CRLF-Injection-Scanner.git
cd CRLF-Injection-Scanner
pip install colored eventlet
cd ..
git clone -b develop https://github.com/tijme/angularjs-csti-scanner.git
cd angularjs-csti-scanner
pip install -r requirements.txt
python setup.py install
wget "https://raw.githubusercontent.com/random-robbie/docker-dump/master/mass-angularjs-csti-scanner/mass-scan" -o /bin/mass-scan
wget "https://raw.githubusercontent.com/random-robbie/docker-dump/master/mass-angularjs-csti-scanner/scan" -o /bin/scan
chmod 777 /bin/scan
chmod 777 /bin/mass-scan
cd ..

# BBF Tooling
echo "[*] Install BBF tooling[*]"
mkdir /usr/share/tools/BBF
cd /usr/share/tools/BBF
for y in $(wget https://bugbountyforum.com/tools/ &&  grep "/tools/" index.html | cut -d "=" -f 2 | cut -d "/" -f 2,3 | grep -v ">"); do wget https://bugbountyforum.com/$y; done && for x in $(ls); do grep "href=" $x | cut -d "=" -f 2 | grep github.com | cut -d "/" -f 3,4,5 | cut -d " " -f 1 |sed -e 's/^"//' -e 's/"$//' | grep -v "gist" >> Repos.txt; done && for a in $(cat Repos.txt);do git clone https://$a; done && find . -maxdepth 1 -type f -delete

echo "deb-src http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list

# s3 bucket checker
echo "[*] Install S3 bucket checker[*]"
mkdir s3-bucket-check
cd s3-bucket-check
wget https://gist.githubusercontent.com/random-robbie/b452cc3e1aa99cfeba764e70b5a26dc8/raw/bucket_upload.sh
wget https://gist.githubusercontent.com/random-robbie/b0c8603e55e22b21c49fd80072392873/raw//bucket_list.sh
cd ..

echo "That's all folks! You're good to go hack the planet!"
