#!/bin/bash
kubeadm join 172.31.2.232:6443 \
  --token 03zmmv.p6wcpb9vmy42uh2j \
  --discovery-token-ca-cert-hash sha256:d463ea0070c0784a26d680ea208f708d7dc954ad2d13785c41ca843bc8081d67 \
  --cri-socket unix:///var/run/cri-dockerd.sock

