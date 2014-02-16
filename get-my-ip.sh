#!/bin/bash
# This is a script of collection of all sorts of remote/outgoing IP address
# retrievals.
#
# Written by and maintained by Yu-Jie Lin
# This script is placed in public domain
#
# If you want to contribute to the list, please fork the Gist and commit, then
# send an email to me (check my GitHub profile for address) since comments on
# Gists generates no notifications. I will pull your Gist if I think I want
# them. Only you also agree to put your code in public domain.
#
# The services used are plain text in response, most are just IP, which is all
# we want. I will not add any services with HTML as response, even with good
# parsing.
# 
# This script only works for IPv4 currently and it doesn't check if the
# returned text as IPv4 address.
#
# Gist  : https://gist.github.com/livibetter/9041330
# Blog  : http://blog.yjl.im/2014/02/getting-ip-address.html
# GitHub: https://github.com/livibetter

RETR_CMD='curl -s -o -'
# Or if you prefer `wget`
# RETR_CMD='wget -q -O -'

############################################################

# functions in alphabetical order

gmip_admin_linux_fr() {
  # http://www.commandlinefu.com/commands/view/12730/external-ip-raw-data
  $RETR_CMD http://utils.admin-linux.fr/ip.php
}

gmip_curlmyip() {
  # http://www.commandlinefu.com/commands/view/12742/external-ip-raw-data
  $RETR_CMD http://curlmyip.com
}

gmip_externalip() {
  # http://stackoverflow.com/a/9618532/242583
  $RETR_CMD http://api.externalip.net/ip
}

gmip_icanhazip() {
  $RETR_CMD http://icanhazip.com
}

gmip_ifconfig_me_ip() {
  $RETR_CMD http://ifconfig.me/ip
}

gmip_ip_api() {
  # http://ip-api.com/docs/api:newline_separated
  $RETR_CMD http://ip-api.com/line | tail -1
}

gmip_ip_appspot() {
  # also work with just HTTP
  $RETR_CMD https://ip.appspot.com
}

gmip_ipinfo_io() {
  # http://stackoverflow.com/a/19698908/242583
  $RETR_CMD ipinfo.io/ip
}

gmip_myip_opendns() {
  # http://www.commandlinefu.com/commands/view/4541/lookup-your-own-ipv4-address
  dig +short @resolver1.opendns.com myip.opendns.com
}

gmip_telize() {
  # http://www.telize.com/
  $RETR_CMD http://www.telize.com/ip
}

gmip_trackip() {
  # http://stackoverflow.com/a/19876824/242583
  $RETR_CMD http://www.trackip.net/ip
}

############################################################

NS=gmip_
FUNCS=()
for f in $(compgen -A function); do
  [[ $f != ${NS}* ]] && continue
  FUNCS+=(${f/$NS/})
done

usage() {
  echo "\
Usage: $(basename -- "$0") [OPTION] [NAMES]

Options;

  -n        dry run, don't actually access the services
  -v        verbose output, shows the function names with IPs
  -h        you are reading it

Names:

  ${FUNCS[@]}
" | fold -s
}

while getopts "nvh" opt; do
  case $opt in
    n)
      DRYRUN=1
      ;;
    v)
      VERBOSE=1
      ;;
    h)
      usage
      exit
      ;;
  esac
done
shift $((OPTIND - 1))

if (($#)); then
  FUNCS=($@)
fi

for f in ${FUNCS[@]}; do
  if ! type $NS$f &>/dev/null; then
    if [[ $VERBOSE ]]; then
      printf "%-16s: %s\n" $f '*no such function*' >&2
    else
      echo "No such function: $f" >&2
    fi
    continue
  fi

  if [[ $DRYRUN ]]; then
    IP='<IP>'
  else
    IP=$($NS$f)
  fi

  if [[ $VERBOSE ]]; then
    printf "%-16s: %s\n" $f $IP
  else
    echo $IP
  fi
done
