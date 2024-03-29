#!/bin/bash

# Init sysctl.conf
cp /etc/sysctl.conf /etc/sysctl.conf.bak
cat>/etc/sysctl.conf<<EOF
fs.file-max=102400

net.core.rmem_max=67108864
net.core.wmem_max=67108864
net.core.rmem_default=524288
net.core.wmem_default=524288
net.core.netdev_max_backlog=4096
net.core.somaxconn=8192

net.ipv4.neigh.default.gc_stale_time=120
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
net.ipv4.conf.default.arp_announce=2
net.ipv4.conf.lo.arp_announce=2
net.ipv4.conf.all.arp_announce=2

net.ipv4.tcp_syncookies=1
net.ipv4.tcp_synack_retries=2
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_tw_recycle=1
net.ipv4.tcp_fin_timeout=10
net.ipv4.tcp_keepalive_time=1200
net.ipv4.ip_local_port_range=10000 65000
net.ipv4.tcp_max_syn_backlog=4096
net.ipv4.tcp_max_tw_buckets=5000
net.ipv4.tcp_fastopen=3
net.ipv4.tcp_fack=1
net.ipv4.tcp_sack=1
net.ipv4.tcp_timestamps=0
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_rmem=4096 524288 67108864
net.ipv4.tcp_wmem=4096 524288 67108864
net.ipv4.tcp_mtu_probing=1
net.ipv4.tcp_no_metrics_save=1
net.ipv4.tcp_slow_start_after_idle=0
net.ipv4.tcp_early_retrans=1
net.ipv4.ip_forward=1

net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr

net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
net.ipv6.conf.lo.disable_ipv6=1
EOF
sysctl -p

# Configure ulimit
cp /etc/security/limits.conf /etc/security/limits.conf.bak
cat>/etc/security/limits.conf<<EOF
root soft nofile 65535
root hard nofile 65535
* soft nofile 65535
* hard nofile 65535
EOF

service supervisor stop
echo 'ulimit -n 65535' >> /etc/default/supervisor
service supervisor start