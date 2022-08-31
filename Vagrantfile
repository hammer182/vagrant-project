$script_mysql = <<-SCRIPT
apt-get update && \
apt-get install -y mysql-server-5.7 && \
mysql -e "create user 'phpuser'@'%' identified by 'pass';"
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
      mysql.vm.provision "shell", inline: $script_mysql
      mysql.vm.provision "shell",
        inline: "cat /configs/mysqld.cnf > /etc/mysql/mysql.conf.d/mysqld.cnf"
      mysql.vm.provision "shell",
        inline: "sudo systemctl restart mysql"
  end

  #PHP
  config.vm.define "phpweb" do |php|
      #Port Forwarding
      php.vm.network "forwarded_port", guest: 80, host: 8089
      #Public Network manually assigned
      php.vm.network "public_network", ip: "192.168.1.66"
  end
end