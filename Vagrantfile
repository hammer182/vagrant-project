$script_mysql = <<-SCRIPT
apt-get update && \
apt-get install -y mysql-server-5.7 && \
mysql -e "create user 'phpuser'@'%' identified by 'pass';"
SCRIPT

$script_puppet = <<-SCRIPT
apt-get update && \
apt install puppet -y
SCRIPT

$script_ansible = <<-SCRIPT
apt-get update && \
apt install software-properties-common -y && \ 
apt install ansible -y
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  #Synced Folders
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder "./configs", "/configs"

  #MySQL
  config.vm.define "mysqldb" do |mysql|
      #Public Network manually assigned
      mysql.vm.network "public_network", ip: "192.168.1.182"    
      #Provisioning
      mysql.vm.provision "shell",
        inline: "cat /configs/id_bionic.pub >> .ssh/authorized_keys"
  end

  #PHP
  config.vm.define "phpweb" do |php|
      #Synced Folder for PHP
      php.vm.synced_folder "./src", "/src"
      #Port Forwarding
      php.vm.network "forwarded_port", guest: 8888, host: 8888
      #Public Network manually assigned
      php.vm.network "public_network", ip: "192.168.1.66"
      #Update packages and install puppet
      php.vm.provision "shell", inline: $script_puppet

      php.vm.provision "puppet" do |puppet|
        puppet.manifests_path = "./configs/manifests"
        puppet.manifest_file = "phpweb.pp"
      end
  end

  config.vm.define "ansible" do |ansible|
      #Public Network manually assigned
      ansible.vm.network "public_network"
      #Provisioning
      ansible.vm.provision "shell", 
        inline: "cp /configs/id_bionic /home/vagrant && \ 
                chmod 600 /home/vagrant/id_bionic && \
                chown vagrant:vagrant /home/vagrant/id_bionic "
      ansible.vm.provision "shell", inline: $script_ansible
      ansible.vm.provision "shell", inline: "ansible-playbook -i /configs/playbooks/hosts /configs/playbooks/playbook.yml"
  end

end