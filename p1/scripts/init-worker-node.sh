echo "Start worker node Script"

cd /etc/yum.repos.d/
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

echo "retrieved token: $(cat /home/vagrant/token)"
token="$(cat /home/vagrant/token)"

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--node-ip=192.168.56.111 --flannel-iface=eth1" K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$token sh -

echo "END worker node Script"
