
# colors 
RED="\033[0;31m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
GREEN="\033[0;32m"
RESET="\033[0m"
NOTIC="\e[5m"
NOTIC_RESET="\e[25m"

# install basics to linux
basicInstall() {
	echo -e "[$GREEN+$RESET] This script will install the required dependencies to run recon.sh, please stand by.."
	echo -e "[$GREEN+$RESET] It will take a while, go grab a cup of coffee :)"
	cd "$HOME" || return
	sleep 1
	echo -e "[$GREEN+$RESET] Getting the basics.."
	export LANGUAGE=en_US.UTF-8
	export LANG=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	sudo apt-get update -y
	sudo apt-get install git -y
	sudo apt-get install -y --reinstall build-essential
	sudo apt install -y python3-pip
	sudo apt install -y file
	sudo apt-get install -y dnsutils
	sudo apt install -y lua5.1 alsa-utils libpq5
	sudo apt-get autoremove -y
	sudo apt clean
	sudo apt install parallel -y
	sudo apt install snap
	sudo apt install whois
	sudo apt install snapd
	sudo apt install screen

	echo -e "[$GREEN+$RESET] Creating directories.."
	mkdir -p "$HOME"/bughunter
	mkdir -p "$HOME"/bughunter/tools
	mkdir -p "$HOME"/bughunter/results
	mkdir -p "$HOME"/bughunter/wordlists
	mkdir -p "$HOME"/go
	mkdir -p "$HOME"/go/src
	mkdir -p "$HOME"/go/bin
	mkdir -p "$HOME"/go/pkg
	sudo chmod u+w .

	echo -e "[$GREEN+$RESET] Installing jq.."
	sudo apt install -y jq
	echo -e "[$GREEN+$RESET] Done."

	echo -e "[$GREEN+$RESET] Installing Chromium browser.."
	sudo apt install -y chromium-browser
	echo -e "[$GREEN+$RESET] Done."

}

# golang install-update
golangInstall() {
	echo -e "[$GREEN+$RESET] Installing and setting up Go.."

	if [[ $(go version | grep -o '1.14') == 1.14 ]]; then
		echo -e "[$GREEN+$RESET] Go is already installed, skipping installation"
	else
		cd /tmp/ || return
		git clone https://github.com/udhos/update-golang
		cd /tmp/update-golang || return
		sudo bash update-golang.sh
		sudo cp /usr/local/go/bin/go /usr/bin/ 
		echo -e "[$GREEN+$RESET] Done."
		rm -r /tmp/update-golang
	fi

	echo -e "[$GREEN+$RESET] Adding alias & Golang to "$HOME"/.bashrc.."
	sleep 1
	configfile="$HOME"/.bashrc

	if [ "$(cat "$configfile" | grep '^export GOPATH=')" == "" ]; then
		echo export GOPATH='$HOME'/go >>"$HOME"/.bashrc
	fi

	if [ "$(echo $PATH | grep $GOPATH)" == "" ]; then
		echo export PATH='$PATH:$GOPATH'/bin >>"$HOME"/.bashrc
	fi

	if [ "$(cat "$configfile" | grep '^alias recon=')" == "" ]; then
		echo "alias recon=$HOME/bughunter/tools/recon/recon.sh" >>"$HOME"/.bashrc
	fi

	bash /etc/profile.d/golang_path.sh

	source "$HOME"/.bashrc

	cd "$HOME" || return
	echo -e "[$GREEN+$RESET] Golang has been configured."
}



# check and install bughunter tools [golang]  
golangTools() {
	if ! command -v subfinder &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing subfinder.."
		GO111MODULE=on go get -u -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] Subfinder already installed."
	fi

	if ! command -v subjack &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing subjack.."
		go get -u -v github.com/haccer/subjack
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] subjack already installed."
	fi

	if ! command -v aquatone &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing aquatone.."
		go get -u -v github.com/michenriksen/aquatone
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] aquatone already installed."
	fi

	if ! command -v httprobe &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing httprobe.."
		go get -u -v github.com/tomnomnom/httprobe
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] httprobe already installed."
	fi

	if ! command -v assetfinder &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing assetfinder.."
		go get -u -v github.com/tomnomnom/assetfinder
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] assetfinder already installed."
	fi

	if ! command -v waybackurls &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing waybackurls.."
		go get github.com/tomnomnom/waybackurls
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] waybackurls already installed."
	fi

	if ! command -v meg &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing meg.."
		go get -u -v github.com/tomnomnom/meg
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] meg already installed."
	fi


	if ! command -v tojson &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing tojson.."
		go get -u -v github.com/tomnomnom/hacks/tojson
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] tojson already installed."
	fi


	if ! command -v unfurl &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing unfurl.."
		go get -u -v github.com/tomnomnom/unfurl
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] unfurl already installed."
	fi


	if ! command -v gf &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing gf.."
		go get -u -v github.com/tomnomnom/gf
		go get -u github.com/tomnomnom/gf
		echo 'source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.bashrc
		cp -r $GOPATH/src/github.com/tomnomnom/gf/examples ~/.gf
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/1ndianl33t/Gf-Patterns
		mkdir -p "$HOME"/.gf
		cp -r "$HOME"/bughunter/tools/Gf-Patterns/*.json ~/.gf
		git clone https://github.com/dwisiswant0/gf-secrets
		cp "$HOME"/bughunter/tools/gf-secrets/.gf/*.json ~/.gf
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] gf already installed."
	fi


	if ! command -v anew &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing anew.."
		go get -u -v github.com/tomnomnom/anew
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] anew already installed."
	fi


	if ! command -v qsreplace &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing qsreplace.."
		go get -u -v github.com/tomnomnom/qsreplace
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] qsreplace already installed."
	fi


	if ! command -v ffuf &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing ffuf.."
		go get -u -v github.com/ffuf/ffuf
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] ffuf already installed."
	fi


	if ! command -v gobuster &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing gobuster.."
		go get -u -v github.com/OJ/gobuster
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] gobuster already installed."
	fi

	if ! command -v gobuster &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing urlive.."
		go get -u github.com/vsec7/urlive
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] urlive already installed."
	fi

	if ! command -v amass &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing amass.."
		sudo snap install amass
		GO111MODULE=on go get -v github.com/OWASP/Amass/v3/...
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] amass already installed."
	fi


	if ! command -v getJS &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing getJS.."
		go get -u -v github.com/003random/getJS
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] getJS already installed."
	fi


	if ! command -v gau &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing gau.."
		go get -u -v github.com/lc/gau
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] gau already installed."
	fi

	if ! command -v crobat &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing crobat.."
		go get -u github.com/cgboal/sonarsearch/crobat
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] crobat already installed."
	fi

	if ! command -v slackcat &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing assetfinder.."
		go get -u github.com/dwisiswant0/slackcat
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] slackcat already installed."
	fi

	if ! command -v github-subdomains &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing github-subdomains.."
		go get -u github.com/gwen001/github-subdomains
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] github-subdomains already installed."
	fi

	if ! command -v shuffledns &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing shuffledns.."
		GO111MODULE=on go get -u -v github.com/projectdiscovery/shuffledns/cmd/shuffledns
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] shuffledns already installed."
	fi


	if ! command -v dnsprobe &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing dnsprobe.."
		GO111MODULE=on go get -u -v github.com/projectdiscovery/dnsprobe
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] dnsprobe already installed."
	fi


	if ! command -v nuclei &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing nuclei.."
		GO111MODULE=on go get -u -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] nuclei already installed."
	fi

:' 
	if ! command -v sqlmap &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing sqlmap.."
		sudo snap install sqlmap
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] sqlmap already installed."
	fi
'

	if ! command -v cf-check &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing cf-check.."
		# go get -u github.com/dwisiswant0/cf-check
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] cf-check already installed."
	fi


	if ! command -v dalfox &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing dalfox.."
		GO111MODULE=on go get -u -v github.com/hahwul/dalfox
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] dalfox already installed."
	fi


	if ! command -v hakrawler &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing hakrawler.."
		go get -u -v github.com/hakluke/hakrawler
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] hakrawler already installed."
	fi


	if ! command -v naabu &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing naabu.."
		GO111MODULE=on go get -u -v github.com/projectdiscovery/naabu/v2/cmd/naabu
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] naabu already installed."
	fi


	if ! command -v chaos &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing chaos.."
		GO111MODULE=on go get -u github.com/projectdiscovery/chaos-client/cmd/chaos
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] chaos already installed."
	fi


	if ! command -v httpx &> /dev/null
	then
		echo -e "[$YELLOW$NOTIC+$RESET$NOTIC_RESET] Installing httpx.."
		GO111MODULE=auto go get -u -v github.com/projectdiscovery/httpx/cmd/httpx
		echo -e "[$GREEN+$RESET] Done."
	else
		echo -e "[$GREEN+$RESET] httpx already installed."
	fi
}


# check-install bughunter tools [from github]
additionalTools() {
	echo -e "[$GREEN+$RESET] Installing massdns.."
	if [ -e /usr/local/bin/massdns ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/blechschmidt/massdns.git
		cd "$HOME"/bughunter/tools/massdns || return
		echo -e "[$GREEN+$RESET] Running make command for massdns.."
		make -j
		sudo cp "$HOME"/tools/massdns/bin/massdns /usr/local/bin/
		echo -e "[$GREEN+$RESET] Done."
	fi


	echo -e "[$GREEN+$RESET] Installing masscan.."
	if [ -e /usr/local/bin/masscan ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/robertdavidgraham/masscan
		cd "$HOME"/bughunter/tools/masscan || return
		make -j
		sudo cp bin/masscan /usr/local/bin/masscan
		sudo apt install libpcap-dev -y
		cd "$HOME"/bughunter/tools/ || return
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing Corsy (CORS Misconfiguration Scanner).."
	if [ -e "$HOME"/tools/Corsy/corsy.py ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/s0md3v/Corsy.git
		cd "$HOME"/bughunter/tools/Corsy || return
		sudo pip3 install -r requirements.txt
		cd "$HOME"/bughunter/tools/ || return
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing dirsearch.."
	if [ -e "$HOME"/tools/dirsearch/dirsearch.py ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/maurosoria/dirsearch.git
		cd "$HOME"/bughunter/tools/ || return
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing Arjun (HTTP parameter discovery suite).."
	if [ -e "$HOME"/tools/Arjun/arjun.py ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		echo -e "[$GREEN+$RESET] Installing Arjun.."
		git clone https://github.com/s0md3v/Arjun.git
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing Dnsgen .."
	if [ -e "$HOME"/tools/dnsgen/setup.py ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/ProjectAnte/dnsgen
		cd "$HOME"/bughunter/tools/dnsgen || return
		pip3 install -r requirements.txt --user
		sudo python3 setup.py install
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing sublert.."
	if [ -e "$HOME"/tools/sublert/sublert.py ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/yassineaboukir/sublert.git
		cd "$HOME"/bughunter/tools/sublert || return
		sudo apt-get install -y libpq-dev dnspython psycopg2 tld termcolor
		pip3 install -r requirements.txt --user
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing findomain.."
	arch=`uname -m`
	if [ -e "$HOME"/bughunter/tools/findomain ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	elif [[ "$arch" == "x86_64" ]]; then
		wget https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-linux -O "$HOME"/tools/findomain
		chmod +x "$HOME"/bughunter/tools/findomain
		sudo cp "$HOME"/bughunter/tools/findomain /usr/local/bin
		echo -e "[$GREEN+$RESET] Done."
	else
		wget https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-aarch64 -O "$HOME"/tools/findomain
		chmod +x "$HOME"/bughunter/tools/findomain
		sudo cp "$HOME"/bughunter/tools/findomain /usr/local/bin
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing LinkFinder.."
	if [ -e "$HOME"/bughunter/tools/LinkFinder/linkfinder.py ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/GerbenJavado/LinkFinder.git
		cd "$HOME"/bughunter/tools/LinkFinder || return
		pip3 install -r requirements.txt --user
		sudo python3 setup.py install
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing CertificateTransparencyLogs.."
	if [ -e "$HOME"/tools/CertificateTransparencyLogs/certsh.py ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/ghostlulzhacks/CertificateTransparencyLogs
		cd "$HOME"/bughunter/tools/CertificateTransparencyLogs || return
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing altdns.."
	if [ -e "$HOME"/bughunter/tools/altdns/setup.py ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/infosec-au/altdns.git
		cd "$HOME"/bughunter/tools/altdns
		sudo python setup.py install
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing s3scanner.."
	if [ -e "$HOME"/bughunter/tools/S3Scanner/setup.py ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/sa7mon/S3Scanner.git
		cd "$HOME"/bughunter/tools/S3Scanner
		sudo pip install -r requirements.txt
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing bass.."
	if [ -e "$HOME"/bughunter/tools/bass/bass.py ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/Abss0x7tbh/bass.git
		cd "$HOME"/bughunter/tools/bass || return
		sudo pip3 install tldextract
		pip3 install -r requirements.txt --user
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing interlace.."
	if [ -e /usr/local/bin/interlace ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/codingo/Interlace.git
		cd "$HOME"/bughunter/tools/Interlace || return
		sudo python3 setup.py install
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing nmap.."
	sudo apt-get install -y nmap
	wget https://raw.githubusercontent.com/vulnersCom/nmap-vulners/master/vulners.nse -O /usr/share/nmap/scripts/vulners.nse && nmap --script-updatedb
	echo -e "[$GREEN+$RESET] Done."

	echo -e "[$GREEN+$RESET] Installing Altdns.."
	pip install py-altdns
	echo -e "[$GREEN+$RESET] Done."

	echo -e "[$GREEN+$RESET] Installing Eyewitness.."
	cd "$HOME"/bughunter/tools/ || return
	git clone https://github.com/FortyNorthSecurity/EyeWitness.git
	sudo bash "$HOME"/bughunter/tools/EyeWitness/Python/setup/setup.sh
	echo -e "[$GREEN+$RESET] Done."

	if [ -e /usr/share/Seclists/Discovery ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		sudo cd /usr/share/ || return
		sudo git clone https://github.com/danielmiessler/SecLists.git
		sudo mv SecLists secLists
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing mini-hacks.."
	
	if [ -e "$HOME"/bughunter/tools/mini-hacks ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/Abdulrahman-Kamel/mini-hacks.git		
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing xss_Headers tool.."
	if [ -e "$HOME"/bughunter/tools/xssHeaders ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/Abdulrahman-Kamel/xssHeaders.git
		cd "$HOME"/bughunter/tools/xssHeaders || return
		pip3 install -r requirements.txt
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing httpAuth.."
	if [ -e "$HOME"/bughunter/tools/httpAuth ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/Abdulrahman-Kamel/httpAuth.git
		cd "$HOME"/bughunter/tools/httpAuth || return
		pip3 install -r requirements.txt 
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing redi-trick.."
	if [ -e "$HOME"/bughunter/tools/redi-trick ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/Abdulrahman-Kamel/redi-trick.git
		echo -e "[$GREEN+$RESET] Done."
	fi
	
	echo -e "[$GREEN+$RESET] Installing CMSeek.."
	if [ -e "$HOME"/bughunter/tools/CMSeek ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/Tuhinshubhra/CMSeeK.git
		cd "$HOME"/bughunter/tools/CMSeek || return
		python3 cmseek.py --update
		pip3 install -r requirements.txt 
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] Installing XSStrike.."
	if [ -e "$HOME"/bughunter/tools/XSStrike ]; then
		echo -e "[$GREEN+$RESET] Already installed."
	else
		cd "$HOME"/bughunter/tools/ || return
		git clone https://github.com/s0md3v/XSStrike.git
		cd "$HOME"/bughunter/tools/XSStrike || return
		echo -e "[$GREEN+$RESET] Done."
	fi

	echo -e "[$GREEN+$RESET] download resolver.txt dns.."
	if [ -f "$HOME"/bughunter/wordlists/resolvers.txt ]; then
		echo -e "[$GREEN+$RESET] Already download"
	else
		wget https://raw.githubusercontent.com/janmasarik/resolvers/master/resolvers.txt -O "$HOME"/bughunter/wordlists/resolvers.txt
	fi
}

basicInstall
golangInstall
golangTools
additionalTools
