salt-iptables
================
## About
Even though the `iptables` configuration has been designed like a formula, it does not contain formula in its name because its design is not consistent with Salt Formula guidelines, specifically the folder structure and the pillar data, instead of using a single `pillar.example` file, which would be inconsistent with the modular design of the firewall states, it uses multiple pillar files, each of which correspond to a file within the `iptables` state. 

This is done so that there aren't multiple `pillar*.example` files within the state.

Given how complex firewall rules can get, I think it's better to separate out the various classes of configuration rules into their own states. That way only the pillar(s) with the class of rules to be modified needs to be changed, leaving the others as is.

Each of the pillars files contain example configuration rules. 

Currently, only the basics are covered: default rules, rules for services, rules for ports, rules for ssh, NAT rules, and whitelists are supported. Additional states and pillars will be added in the future to support other chains and rule classes. 

This state also ensures that Ubuntu's default firewall, `ufw`, is purged, along with any files associated with it.

### Note
This module manages your firewall using iptables with pillar configured rules. 
Thanks to the nature of Pillars it is possible to write global settings along with environment, role, or any glob based matching to specify additonal firewall rules. Just make sure that their IDs are unique.

For `ssh` connections, two types are defined, `restricted` and `server`. These are identifed by matching on the value for the `ssh` role. By default, `restricted` is used, unless the `ssh` role equals `server`.

For _Debian_ based systems, including _Ubuntu_, `iptables-persistent` is also installed.

All the configuration for the firewall is done via pillars. The `pillars/iptables/init.sls` specifies the pillars to be included, along with doing the evaluation on which `ssh` pillar should be used.

Each state file within the `pillars/iptables` directory contains an example configuration.