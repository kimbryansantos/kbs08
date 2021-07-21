#!/bin/bash
#
echo 'fs.protected_fifos = 2' >> /etc/sysctl.conf
sysctl -w fs.protected_fifos=2
#
echo 'fs.protected_regular = 2' >> /etc/sysctl.conf
sysctl -w fs.protected_regular=2
#
echo 'kernel.dmesg_restrict = 1' >> /etc/sysctl.conf
sysctl -w kernel.dmesg_restrict=1
#
echo 'kernel.kptr_restrict = 2' >> /etc/sysctl.conf
sysctl -w kernel.kptr_restrict=2
#
echo 'kernel.perf_event_paranoid = 3' >> /etc/sysctl.conf
sysctl -w kernel.perf_event_paranoid=3
#
echo 'kernel.sysrq = 0' >> /etc/sysctl.conf
sysctl -w kernel.sysrq=0
#
echo 'kernel.yama.ptrace_scope = 1' >> /etc/sysctl.conf
sysctl -w kernel.yama.ptrace_scope=1
#
echo 'net.core.bpf_jit_harden = 2' >> /etc/sysctl.conf
sysctl -w net.core.bpf_jit_harden=2
#
#
#
sed -i -E "s/#*Compression.*/Compression no/" /etc/ssh/sshd_config
#
sed -i -E "s/#*LogLevel.*/LogLevel verbose/" /etc/ssh/sshd_config
#
sed -i -E "s/#*TCPKeepAlive .*/TCPKeepAlive no/" /etc/ssh/sshd_config
#
sed -i -E "s/#*AllowAgentForwarding .*/AllowAgentForwarding no/" /etc/ssh/sshd_config
#
#
#
IP=$( nmcli | sed -E -n "/: connected to/,/inet4/{/inet4/ s/.*inet4[[:space:]](.*)\/.*/\1/p}" )
sed -i  "/${IP}.*/d" /etc/hosts
echo "$IP $(hostname)" >> /etc/hosts
#
#
#
echo -e \
"blacklist firewire-ohci\n\
blacklist firewire-sbp2" \
>> /etc/modprobe.d/blacklist-firewire.conf
#
echo "install dccp /bin/true" >> /etc/modprobe.d/dccp.conf
#
#
#
sed -i -E "s/(.*umask[[:space:]]+)[[:digit:]]+(.*)/\1027\2/" /etc/csh.cshrc
#
sed -i -E "s/(.*umask[[:space:]]+)[[:digit:]]+(.*)/\1027\2/" /etc/init.d/functions
#
#
#
chmod 440 /etc/sudoers.d/*
#
#
#
echo -e \
"SHA_CRYPT_MIN_ROUNDS 10000\n\
SHA_CRYPT_MAX_ROUNDS 50000" \
>> /etc/login.defs
#
yum -y install arpwatch
systemctl enable arpwatch
systemctl start arpwatch
#
sed -i -E "s/([^[:space:]]+[[:space:]]+\/boot[[:space:]]+[^[:space:]]+[[:space:]]+[^[:space:]]+)([[:space:]]+.*)/\1,nodev,nosuid,noexec\2/" /etc/fstab
#
mount | sed -En "s/([^[:space:]]+)[[:space:]]+on[[:space:]]+(\/dev)[[:space:]]+type[[:space:]]+([^[:space:]]+)[[:space:]]\(([^\)]+)\)/\1 \2 \3 \4,noexec,nodev 0 0/p" >> /etc/fstab