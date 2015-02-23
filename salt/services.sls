# base\iptables\services.sls
# services: define the rules for the specified services.
#

{% if salt['pillar.get']('iptables:enabled') %}
  {% set iptables = salt['pillar.get']('iptables-services', {}) %}
  {% for service_name, service_details in iptables.get('services', {}).items() %}
    {% set block_nomatch = service_details.get('block_nomatch', False) %}

    # Allow rules for ips/subnets
    {% for ip in service_details.get('ips_allow',{}) %}
      iptables_{{service_name}}_allow_{{ip}}:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - source: {{ ip }}
          - dport: {{ service_name }}
          - proto: tcp
          - save: True
    {% endfor %}

    {% if block_nomatch %}
      # If a block_nomatch is set, add the rule
      iptables_{{service_name}}_deny_other:
        iptables.append:
          - position: last
          - table: filter
          - chain: INPUT
          - jump: REJECT
          - dport: {{ service_name }}
          - proto: tcp
          - save: True
    {% endif %}    

  {% endfor %}
{% endif %}