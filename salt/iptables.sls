# base/iptables/iptables.sls
# Install iptables and set the defaults
# TODO: set OUTPUT filter's default to DROP so that output rules need to be
#   defined.
#
{%- if salt['pillar.get']('iptables:enabled') %}
  {% set iptables = salt['pillar.get']('iptables', {}) %}
  {% set install = iptables.get('install', False) %}
  {% set strict_mode = iptables.get('strict', False) %}
  {% set global_block_nomatch = iptables.get('block_nomatch', False) %}
  {% set packages = salt['grains.filter_by']({
    'Debian': ['iptables', 'iptables-persistent'],
    'RedHat': ['iptables'],
    'default': 'Debian'}) %}

      {%- if install %}
      # Install required packages for iptables
      iptables_packages:
        pkg.installed:
          - pkgs:
            {%- for pkg in packages %}
            - {{pkg}}
            {%- endfor %}
      {%- endif %}

      # Always allow localhost
      iptables_allow_localhost:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - source: 127.0.0.1
          - save: True

      # Allow related/established sessions
      iptables_allow_established:
        iptables.append:
          - table: filter
          - chain: INPUT
          - jump: ACCEPT
          - match: conntrack
          - ctstate: 'RELATED,ESTABLISHED'
          - save: True            

      # Set the policy to deny everything unless defined
      enable_input_drop_policy:
        iptables.set_policy:
          - table: filter
          - chain: INPUT
          - policy: DROP
          - require:
            - iptables: iptables_allow_localhost
            - iptables: iptables_allow_established

      # Set the policy to deny forwards unless defined
      enable_forward_drop_policy:
        iptables.set_policy:
          - table: filter
          - chain: FORWARD
          - policy: DROP

{%- endif %}
