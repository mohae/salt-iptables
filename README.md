salt-iptables
================
## About
Even though the `iptables` configuration has been designed like a formula, it does not contain formula in its name because its design is not consistent with Salt Formula guidelines. As a result, this wouldn't be gettable, like Salt Formula's are meant to be, using Salt's GitFS remote. I may address this in the future by creating a separate `iptables-formula` that contains only the contents of `salt-iptables/salt/iptables`, but, for now, I'd rather keep the Salt state and Salt pillar for `iptables` together, in the same repository.

The structure of this repository deviates from Salt Formulas because of the way I decided to structure both the pillar data and states themselves. Instead of using a single `pillar.example` file, which would be inconsistent with the modular design of the iptable states within this repo. This repo uses multiple pillar files, each of which correspond to the file within the `iptables` state that is responsible for processing and adding those rules to `iptables. 

This is done so that there aren't multiple `pillar*.example` files within the state.

Given how complex firewall rules can get, I think it's better to separate out the various classes of configuration rules into their own states. That way only the pillar(s) with the class of rules to be modified needs to be changed, leaving the others as is.

Each of the pillars files contain example configuration rules. 

Currently, only the basics are covered: default rules, rules for services, rules for ports, rules for ssh, NAT rules, and whitelists are supported. Additional states and pillars will be added in the future to support other chains and rule classes. 

This state also ensures that Ubuntu's default firewall, `ufw`, is purged, along with any files associated with it.

The goal of this state is to, by default, have a firewall that is enabled and properly secured, if minimally secured. It should support additional rules that enable Ops to configure their firewall as they see fit. It should also enable rule persistence.

### Differences from https://github.com/saltstack-formulas/iptables-formulas
The `iptables-formula` in the "saltstack-formulas" organization is structured differently. It has a separate `service.sls` state to enable extending of the state for custom pillar data. The `pillar.example` file contains a few basic examples which may or may not be useful. From my experience, the `nat` example does not work. The README.md` has a few more examples and it directs you to create separate pillar states for everything. 

The separate `service.sls` is not necessary in order to support merging of pillars and needlessly complicates things. I'm not saying my more modular approach doesn't complicate things, but it doesn't contain needless state files to work around imagined issues.

Just don't give your pillars the same ID and you'll be fine. Instead, rely on Salt's handling of pillar data to properly merge your rules.

### Note
This module manages your firewall using iptables with pillar configured rules. 
Thanks to the nature of Pillars it is possible to write global settings along with environment, role, or any glob based matching to specify additonal firewall rules. Just make sure that their IDs are unique.

For `ssh` connections, two types are defined, `restricted` and `server`. These are identifed by matching on the value for the `ssh` role. By default, `restricted` is used, unless the `ssh` role equals `server`.

For _Debian_ based systems, including _Ubuntu_, `iptables-persistent` is also installed.

All the configuration for the firewall is done via pillars. The `pillars/iptables/init.sls` specifies the pillars to be included, along with doing the evaluation on which `ssh` pillar should be used.

Each state file within the `pillars/iptables` directory contains an example configuration.

### TODO
This is only a start. I would like to:

* Set the OUTBOUND default to be DROP
* Add rules to explicitly allow OUTBOUND connections.
* Add other chains.
* Add rules for logging
* Add rules for handling SYN
* Add limiting rules on both connections and frequency to certain ports

All in all, add additional states to support a more secure `iptables` configuration. It should support the common types of rules that are used. 