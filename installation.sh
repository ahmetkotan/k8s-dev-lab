#!/usr/bin/env bash

sudo kubeadm init --apiserver-advertise-address=192.168.224.2 --pod-network-cidr=10.244.0.0/16

mkdir -p "$HOME/.kube"
sudo cp -i /etc/kubernetes/admin.conf "$HOME/.kube/config"
sudo chown "$(id -u)":"$(id -g)" "$HOME/.kube/config"

echo ""
echo ""

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo ""
echo "Waiting pods..."
kubectl wait --for=condition=Ready pods --all -n kube-system --timeout=-1s

echo "KUBELET_EXTRA_ARGS=--node-ip=192.168.224.2" | sudo tee /etc/default/kubelet > /dev/null
sudo systemctl restart kubelet


KUBE_TOKEN=$(kubeadm token list -o 'jsonpath={..token}')
CERT_HASH=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt \
    | openssl rsa -pubin -outform der 2>/dev/null \
    | openssl dgst -sha256 -hex \
    | sed 's/^.* //')

echo "sudo kubeadm join 192.168.224.2:6443 --token $KUBE_TOKEN --discovery-token-ca-cert-hash sha256:$CERT_HASH" > join.sh
chmod +x join.sh
