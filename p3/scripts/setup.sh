#!/bin/bash

# docker installation
apt-get update -y

apt-get install ca-certificates curl gnupg

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y

apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# install k3d - START
# install kubctl - START
echo "Installing k3d - START"
curl https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.0.0 bash

k3d cluster create iot-cluster -p "8080:8080" -p "30007-30443:30007-30443"
# TODO - wait for cluster to be ready

echo "Installing k3d - END"
# install k3d - END

# install kubectl - START
echo "Installing kubectl - START"

curl -o /usr/local/bin/kubectl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl"

chmod +x /usr/local/bin/kubectl

echo "Installing kubectl - END"

# install kubctl - END


# install argocd - START
echo "Installing argocd - START"

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Installing argocd - END"

# install argocd - END

# wait for argocd services to be up
echo "Starting argocd..."

while true; do 
  result=$(kubectl get pods -n argocd | grep "0/1")

  if [ "$result" = "" ]; then
    echo "done - argocd is ready."
    break
  fi

  echo "waiting - argocd not ready yet..."
  sleep 10

done

# applaying argocd application - START
echo "applaying argocd application - START"

kubectl apply -f ./config/argocd-application.yaml

echo "applaying argocd application - END"
# applaying argocd application - END


# get argocd password
# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
