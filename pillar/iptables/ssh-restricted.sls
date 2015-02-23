 # pillar/basea/iptables/ssh-restricted.sls
 # ssh-restricted defines sources from which ssh connections will be accepted.
 #
 iptables-ssh-restricted:
    ssh:
      block_nomatch: True
      ips_allow:
        - 192.168.0.0/24
        - 10.0.2.2/32