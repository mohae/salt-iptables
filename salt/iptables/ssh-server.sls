# base/iptables/ssh-server.sls
# ssh-server: allow ssh connections from all connections
#
{% if salt['pillar.get']('iptables:enabled') %}
  {% set iptables = salt['pillar.get']('iptables-ssh-server', {}) %}
  {% set ssh_details = iptables.get('ssh') %}
  {% set port = ssh_details.get('port', 22) %}
  iptables_{{port}}_allow:
    iptables.append:
      - table: filter
      - chain: INPUT
      - jump: ACCEPT
      - dport: {{ port }}
      - proto: tcp
      - save: True
{% endif %}