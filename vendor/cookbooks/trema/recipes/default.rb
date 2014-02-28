#
# Cookbook Name:: trema
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{git libpcap-dev libsqlite3-dev libglib2.0-dev tmux vim graphviz mini-httpd}.each do | package_name |
  package package_name
end
# needed in vagrant-lxc-precise-amd64-2013-10-23.box
execute "mkdir /dev/net; mknod /dev/net/tun c 10 200; chmod 0666 /dev/net/tun" do
  not_if { ::File.exists?("/dev/net/tun") }
end

gem_package "trema"

#git "/home/vagrant/trema" do
#  repository "https://github.com/trema/trema.git"
#  revision "master"
#  action :sync
#  user "vagrant"
#  group "vagrant"
#end

git "/home/vagrant/trema-apps" do
  repository "https://github.com/trema/apps.git"
  revision "master"
  action :sync
  user "vagrant"
  group "vagrant"
end

git "/home/vagrant/trema-tutorial" do
  repository "https://github.com/trema/tutorial.files.git"
  revision "master"
  action :sync
  user "vagrant"
  group "vagrant"
end

git "/home/vagrant/ruby_topology" do
  repository "https://github.com/yasuhito/ruby_topology.git"
  revision "develop"
  action :sync
  user "vagrant"
  group "vagrant"
end

gem_package "bundler"

rvm_shell "bundle install" do
  cwd "/home/vagrant/ruby_topology"
  code "bundle install"
end

bash "start mini-httpd" do
  user "root"
  code <<-'EOT'
    mkdir -p /home/vagrant/public_html
    cp /usr/share/mini-httpd/html/index.html /home/vagrant/public_html
    chown -R vagrant.vagrant /home/vagrant/public_html
    cp /etc/default/mini-httpd /etc/default/mini-httpd.orig
    sed -e 's/START=0/START=1/' < /etc/default/mini-httpd.orig > /etc/default/mini-httpd
    cp /etc/mini-httpd.conf /etc/mini-httpd.conf.orig
    sed -e 's/host=localhost/host=0.0.0.0/' -e 's/data_dir=\/usr\/share\/mini-httpd\/html/data_dir=\/home\/vagrant\/public_html/' < /etc/mini-httpd.conf.orig > /etc/mini-httpd.conf
    service mini-httpd start
  EOT
end
