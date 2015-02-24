# base/iptables/port.sls
# port: define the rules for the specified ports
#
{% if salt['pillar.get']('iptables:enabled') %}
  {% set iptables = salt['pillar.get']('iptables-nat', {}) %}
  {% for network_interface, nat_details in iptables.get('nat', {}).items() %}  
    {% for ip_s, ip_d in nat_details.get('rules', {}).items() %}
      iptables_{{network_interface}}_allow_{{ip_s}}_{{ip_d}}:
        iptables.append:
          - table: nat 
          - chain: POSTROUTING 
          - jump: MASQUERADE
          - o: {{ network_interface }} 
          - source: {{ ip_s }}
          - destination: {{ ip_d }}
          - save: True
    {% endfor %}
  {% endfor %}
{% endif %}