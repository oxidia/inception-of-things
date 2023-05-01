cd /etc/yum.repos.d/
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*


curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --flannel-iface=eth1" sh -s -
/usr/local/bin/kubectl create -f /vagrant/config/app-one.yaml
/usr/local/bin/kubectl create -f /vagrant/config/app-one-service.yaml

/usr/local/bin/kubectl create -f /vagrant/config/app-two.yaml
/usr/local/bin/kubectl create -f /vagrant/config/app-two-service.yaml

/usr/local/bin/kubectl create -f /vagrant/config/app-three.yaml
/usr/local/bin/kubectl create -f /vagrant/config/app-three-service.yaml

/usr/local/bin/kubectl create -f /vagrant/config/ingress.yaml
