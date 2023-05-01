
echo "Start master node Script"

cd /etc/yum.repos.d/
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --flannel-iface=eth1" K3S_KUBECONFIG_MODE="644" sh -

cat /var/lib/rancher/k3s/server/token

sudo cp /var/lib/rancher/k3s/server/token /home/vagrant/token

sudo chmod 644 /home/vagrant/token

echo "alias k=kubectl" >> /home/vagrant/.bashrc

echo "END master node Script"
