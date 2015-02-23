# pillar/base/iptables/ports.sls
# ports: define the port rules. Ports do not support sources, use services for
#   that; they do support protocols, tcp is the default.
#
# Note: currently the for loop on getting the protocol uses the default value,
#   'tcp', one character at a time, so explicitly specify the proto.
#
iptables-ports:
  ports:
    keyserver:
      port: 11371
      proto:
        - tcp
    dns:
      port: 54
      proto:
        - tcp
        - udp
