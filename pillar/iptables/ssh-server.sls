 # pillar/base/iptables/ssh-server.sls
 # ssh-server accepts connections from anywhere
 iptables-ssh-server:
    ssh:
      port: 22
