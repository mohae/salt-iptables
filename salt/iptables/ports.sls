# base/iptables/port.sls
# port: define the rules for the specified ports
#
{% if salt['pillar.get']('iptables:enabled') %}
  {% set iptables = salt['pillar.get']('iptables-ports', {}) %}
  {% for port_name, port_details in iptables.get('ports', {}).items() %}  
    # Allow rules
    {% set port = port_details.get('port') %}
    {% for proto in port_details.get('proto', 'tcp') %}
      iptables_{{port_name}}_allow_{{proto}}:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - dport: {{ port }}
          - proto: {{ proto }}
          - save: True
    {% endfor %}
  {% endfor %}
{% endif %}