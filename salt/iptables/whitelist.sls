# base/iptables/port.sls
# port: define the rules for the specified ports
#
{% if salt['pillar.get']('iptables:enabled') %}
  {% set iptables = salt['pillar.get']('iptables-whitelist', {}) %}
  {% for networks, whitelist_details in iptables.get('whitelist', {}).items() %}
    {% for ip in whitelist_details.get('ips_allow',{}) %}
      iptables_{{networks}}_allow_{{ip}}:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - source: {{ ip }}
          - save: True
    {% endfor %}
  {% endfor %}
{% endif %}