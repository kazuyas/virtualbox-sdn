#
# Cookbook Name:: trema
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{ruby1.9.3 git libpcap-dev libsqlite3-dev libglib2.0-dev tmux vim graphviz}.each do |package_name|
	package package_name
end

gem_package "trema"

#git "/home/vagrant/trema" do                            
#    repository "https://github.com/trema/trema.git"
#    revision "master"                                   
#    action :sync                                     
#    user "vagrant"                                    
#    group "vagrant"  
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

execute "bundle install" do
  cwd "/home/vagrant/ruby_topology"
end
