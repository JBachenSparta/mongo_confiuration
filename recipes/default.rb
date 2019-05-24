#
# Cookbook:: chefProxy
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

apt_update 'update_sources' do
  action :update
end

package 'mongodb-org' do
  action :upgrade
end


apt_repository 'mongodb-org' do
  uri "http://repo.mongodb.org/apt/ubuntu"
  distribution "xenial/mongodb-org/3.2"
  components ["mulitverse"]
  keyserver "hkp://keyserver.ubuntu.com:80"
  key "EA312927"
end

service 'mongodb-org' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

#
# template '/data/configdb/mongod.service' do
#   source 'mongod.service.erb'
#   variables proxy_port: 27017
#   # notifies :restart, 'service[nginx]'
# end

template '/etc/mongod.conf' do
  source 'mongod.conf.erb'
  variables proxy_port: 27017
  # notifies :restart, 'service[mongodb-org]'
end

link '/etc/mongod.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
  notifies :restart, 'service[mongodb]'
end

# link '/etc/nginx/sites-enabled/default' do
#   notifies :restart, 'service[nginx]'
#   action :delete
# end


include_recipe "nodejs"

nodejs_npm 'pm2'
