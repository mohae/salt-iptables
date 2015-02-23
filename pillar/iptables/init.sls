# pillar/base/iptables/init.sls
# include the states with the firewall rules
# base installs iptables and creates the default rules
# ssh-server allows ssh connections from anywhere
# ssh-restricted only allows ssh connections from specified sources
# services define rules for services, these can be restricted by IP and use
#   TCP. block_nomatch can be specified.
# ports define rules for ports. No IP restrictions are applied and the 
#   protcol(s) that are used can be defined.
# nat defines the NAT rules.
# whitelist defines whitelisted networks
#
{% if grains['ssh'] == 'server' %}
  {% set ssh = 'iptables.ssh-server' %}
{% else %}
  {% set ssh = 'iptables.ssh-restricted' %}
{% endif %}

include:
  - iptables.base
  - iptables.ssh-server
  - {{ ssh }}
  - iptables.services
  - iptables.ports
  - iptables.nat
  - iptables.whitelist

