# iptables-formula\iptables\ufw.sls
# Ensures that ufw does not exist on Ubuntu; just use iptables.
{% if grains['os'] == 'Ubuntu' %}
ufw:
  pkg.purged

/etc/ufw:
  file.absent
{%- endif %}