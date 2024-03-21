#!/bin/sh

kludge_tunnel(){
  PUBLIC_IP=18.116.38.68
  OCP_API_IP=172.29.172.200
  OCP_APP_IP=172.29.172.201
  OCP_DNS_NAME=cluster.example.com

  echo "Setup your dns to resolve:

  *.apps.${OCP_DNS_NAME}  ${PUBLIC_IP}
  api.${OCP_DNS_NAME}     ${PUBLIC_IP}
  "


  ssh -N \
    root@"${PUBLIC_IP}" \
    -R 0.0.0.0:80:"${OCP_APP_IP}":80 \
    -R 0.0.0.0:443:"${OCP_APP_IP}":443 \
    -R 0.0.0.0:6443:"${OCP_API_IP}":6443
}

kludge_test(){
  curl -k \
    --connect-to 18.116.38.68:443:example-codekow.apps.cluster1.example.com:443 \
    https://example-codekow.apps.cluster1.example.com
}

kludge_iptables(){
  iptables -t nat \
    -I PREROUTING \
    --src 143.166.117.0/24 \
    -p tcp --dport 80 \
    -j REDIRECT --to-ports 22
}

kludge_tunnel
