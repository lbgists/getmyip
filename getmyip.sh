#!/usr/bin/env bash
# Getting IP address in Bash and on Linux
# Written by Yu-Jie Lin
# Public Domain or UNLICENSE
#
# This short script was inspired by a piece of Python code [1], which actually
# was done by many C codes already, for example, this C code [2].
#
# [1] https://github.com/mairieli/snowboard/blob/7560649/Server/server.py
# [2] http://stackoverflow.com/a/6494065/242583
#
# Bash has a feature to open TCP/UDP socket, but there is not getsockname(2),
# this script relies on /proc/$$/net/udp for the local address, therefore it's
# less likely to be portable. Beside that, grep is the only other dependency.
#
# This type of method uses a connection to name server, which makes sense since
# they should be required to be more reliable in terms of uptime. In other the
# codes, Google's public name servers are always used, in this case, 8.8.8.8.
#
# It connects the server via UDP and get the local IP address. Note that the
# address may not be the actual public IP address, depending on the network
# environment. That being said, this method may not be applicable.

exec 3<>/dev/udp/8.8.8.8/53
hexaddr=$(grep -o '........:.... 08080808:0035' /proc/$$/net/udp)
exec 3<&-
[[ $hexaddr ]] || exit 1

for ((i = 3; i >= 0; i--)); do
  ((i != 3)) && printf .
  printf '%d' 0x${hexaddr:i*2:2}
done
echo
