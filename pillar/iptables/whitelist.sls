# pillar/base/iptables/whitelist.sls
# whitelist: rules for whitelisted networks
#
iptables-whitelist:
  whitelist:
    networks:
      ips_allow:
        - 10.0.0.0/8