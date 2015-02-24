# salt/base/iptables/init.sls
# include the states for iptables
#

{% if grains['ssh'] == 'server' %}
  {% set ssh = 'ssh-server' %}
{% else %}
   {% set ssh = 'ssh-restricted' %}
{% endif %}

include:
  - iptables.ufw
  - iptables.iptables
  - iptables.{{ ssh }}
  - iptables.services
  - iptables.ports
  - iptables.nat
  - iptables.whitelist  