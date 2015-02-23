# base/iptables/ssh-restircted.sls
# ssh-internal: defines sources that from which ssh connections will be accepted.
# If ssh-server isn't specified, only restricted connections are allowed
#
{% if salt['pillar.get']('iptables:enabled') %}
  {% set iptables = salt['pillar.get']('iptables-ssh-restricted', {}) %}
  {% set ssh_details = iptables.get('ssh') %}
  {% set block_nomatch = ssh_details.get('block_nomatch', False) %}
  {% set port = ssh_details.get('port', 22) %}

    # Allow rules for ips/subnets
    {% for ip in ssh_details.get('ips_allow', {}) %}
      iptables_{{ port }}_allow_{{ip}}:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - source: {{ ip }}
          - dport: {{ port }}
          - proto: tcp
          - save: True
    {% endfor %}

    {% if block_nomatch %}
    # If a block_nomatch is set, add the rule
      iptables_{{ port }}_block_nomatch:
        iptables.append:
          - position: last
          - table: filter
          - chain: INPUT
          - jump: REJECT
          - dport: {{ port }}
          - proto: tcp
          - save: True
    {% endif %}    

{% endif %}