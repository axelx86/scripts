#!/bin/sh

DIR=`/usr/bin/pwd`
yum install -y -q dialog
export NCURSES_NO_UTF8_ACS=1
result=$(dialog --clear --backtitle "IT PROFIT" --checklist "What do you want to install?:" 0 0 0 \
1 "Motd" on \
2 "Aliases" on  \
3 "Sngrep" off \
4 "MC" on \
5 "FreePBX logo" off \
6 "SSH-Cert" off  \
7 "Asteirks" off \
2>&1 >/dev/tty)

sip=$(dialog --backtitle "IT PROFIT" --menu "Which sip-driver do you use?:" 0 0 0 \
1 "PJSIP" \
2 "Chan_sip" \
2>&1 >/dev/tty)

clear


function_motd () {
					#wget -q http://itpr32.ru/itpr_intro -O /usr/bin/itpr_intro
					#/usr/bin/cp -f ./itpr_intro /usr/bin/itpr_intro
					/usr/bin/cp -f $DIR/itpr_intro /usr/bin/itpr_intro
					chmod +x /usr/bin/itpr_intro
					sed -i '/if \[ -e "$FWCONSOLE" \] ; then/a /usr/bin/itpr_intro' /etc/profile.d/motd.sh
					}
### TODO   пропадают двойные кавычки
		function_aliases () {
						echo "alias ra='fwconsole restart'
alias sip='nano /etc/asterisk/sip_additional.conf'
alias a='asterisk -rvvvvvvvv'
alias a0='asterisk -r'
alias e='nano /etc/asterisk/extensions_custom.conf'
alias d='asterisk -rx "dialplan reload"'
alias s='NCURSES_NO_UTF8_ACS=1 sngrep port 5060'
alias u='asterisk -rx "core show calls uptime"'
alias takeover='/usr/share/heartbeat/hb_takeover'
alias myip='wget -O - -q icanhazip.com'
alias wt='watch -n 0.3 '\''asterisk -x "core show calls"'\'''
alias sngrep='NCURSES_NO_UTF8_ACS=1 sngrep'
alias ax='asterisk -rx "$1"'
" >> /root/.bashrc
						case $sip in
						1)
						echo "alias pp='asterisk -rx "pjsip show contacts" | grep -i '
alias r='asterisk -rx "pjsip show registrations"'
alias p='asterisk -rx "pjsip show contacts"'
" >> /root/.bashrc
						;;
						2)
						echo "alias pp='asterisk -rx "sip show peers" | grep -i '
alias r='asterisk -rx "sip show registry"'
alias p='asterisk -rx "sip show peers"'
" >> /root/.bashrc
						;;
						esac
						. ~/.bashrc
						}

function_sngrep () {
					centos=$(cat /etc/centos-release-upstream | grep -Eo '[0-9]' | head -n 1)
					case $centos in
						6)
						yum install -e -y http://packages.irontec.com/centos/6/x86_64/sngrep-1.4.6-0.el6.x86_64.rpm
						;;
						7)
						yum install -q -y http://packages.irontec.com/centos/7/x86_64/sngrep-1.4.6-0.el7.x86_64.rpm
						;;
						*)
						echo -e "Can't determine centos version. Is it real CentOS? \nTry to get it here http://packages.irontec.com/centos"
					esac
					}

					
					
					
					
function_mc () {
				yum install mc -y
				}

				
				
				
				
function_freepbx_logo () {
			#wget -q http://itpr32.ru/logo_small.png -O /var/www/html/admin/images/logo_small.png
			/usr/bin/cp -f $DIR/logo_small.png /var/www/html/admin/images/logo_small.png
			#wget -q http://itpr32.ru/top_logo.png -O /var/www/html/admin/images/top_logo.png
			/usr/bin/cp -f $DIR/top_logo.png /var/www/html/admin/images/top_logo.png
			wget -q http://itpr32.ru/itpr_favicon.ico -O /var/www/html/admin/images/itpr_favicon.ico
			/usr/bin/cp -f $DIR/itpr_favicon.ico /var/www/html/admin/images/itpr_favicon.ico
			fpbx_pass=$(awk -F= '/^.*AMPDBPASS/{gsub(/ /,"",$2);print $2}' /etc/freepbx.conf | sed 's/";//;s/"//')
			mysql --user=freepbxuser --password=$fpbx_pass asterisk <<EOF
	REPLACE INTO \`freepbx_settings\` (\`keyword\`, \`value\`, \`name\`, \`level\`, \`description\`, \`type\`, \`options\`, \`defaultval\`, \`readonly\`, \`hidden\`, \`category\`, \`module\`, \`emptyok\`, \`sortorder\`) VALUES	
	('BRAND_IMAGE_FAVICON', 'images/itpr_favicon.ico', 'Favicon', 1, 'Favicon', 'text', '', 'images/favicon.ico', 1, 1, 'Styling and Logos', '', 0, 40),
	('BRAND_IMAGE_FREEPBX_LINK_LEFT', 'http://www.itprofit32.ru', 'Link for Left Logo', 1, 'link to follow when clicking on logo, defaults to http://www.freepbx.org', 'text', '', 'http://www.freepbx.org', 1, 0, 'Styling and Logos', '', 1, 100),
	('BRAND_IMAGE_SPONSOR_FOOT', 'images/logo_small.png', 'Image: Footer', 1, 'Logo in footer.Path is relative to admin.', 'text', '', 'images/sangoma-horizontal_thumb.png', 1, 0, 'Styling and Logos', '', 1, 50),
	('BRAND_IMAGE_SPONSOR_LINK_FOOT', 'http://www.itprofit32.ru', 'Link for Sponsor Footer Logo', 1, 'link to follow when clicking on sponsor logo', 'text', '', 'http://www.sangoma.com', 1, 0, 'Styling and Logos', '', 1, 120),
	('BRAND_IMAGE_TANGO_LEFT', 'images/top_logo.png', 'Image: Left Upper', 1, 'Left upper logo.Path is relative to admin.', 'text', '', 'images/tango.png', 1, 0, 'Styling and Logos', '', 0, 40);
EOF
					}

						
						
						
function_ssh_cert () {	
						echo "Alexey have todo it"		
						}

						
						
function_asteriks  () {
						#wget -q http://itpr32.ru/asteriks -O /usr/bin/asteriks
						/usr/bin/cp -f $DIR/asteriks /usr/bin/asteriks
						chmod +x /usr/bin/asteriks
						}




for res in $result
			do
			case $res in
					 1)
					 echo "Modifying motd.sh"
					 function_motd
					 echo "Done!"
					 ;;
					 2)
					 echo "Adding aliases at .bashrc"
					 function_aliases
					 echo "Done!"
					 ;;
					 3)
					 echo "Insatallng SNGREP"
					 function_sngrep
					 echo "Done!"
					 ;;
					 4)
					 echo "Insatallng Midnight Comander"
					 function_mc
					 echo "Done!"
					 ;;
					 5)
					 echo "Making IT PROFIT branding "
					 function_freepbx_logo
					 echo "Done!"
					 ;;
					 6)
					 echo "Installing open RSA key for SSH"
					 function_ssh_cert
					 echo "Done!"
					 ;;
					 7)
					  echo "Installing Asteriks [and Obeliks] application"
					 function_asteriks
					 echo "Done!"
			esac
done
