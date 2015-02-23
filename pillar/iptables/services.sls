iptables-services:
  services:
    rsync:
      block_nomatch: False
      ips_allow:
        - 10.0.0.0/8
    3306:
      block_nomatch: True
      ips_allow:
        - 10.0.0.0/8
