#!/bin/bash
kubeadm join 172.31.1.228:6443 --token lacx3d.186pwi3p4opq7sv2 \
  --discovery-token-ca-cert-hash sha256:2ff6cbc30dc4d95033657ef009cdaa7b76dcf3b630a3500376034b595ae9a25a \
  --cri-socket unix:///var/run/cri-dockerd.sock
