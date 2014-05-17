# Encoding: utf-8
#
# Cookbook Name:: icinga
# Recipe:: default
#
# Copyright 2014, Mariani Lucas
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe 'yum-epel' if platform_family?('rhel', 'fedora')
include_recipe 'apt' if platform_family?('debian')
include_recipe 'apache2'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_python'
include_recipe 'apache2::mod_dir'
include_recipe 'apache2::mod_cgi'
include_recipe 'mysql::server'
include_recipe 'database::mysql'

node[:icinga][:core][:packages].each do |pkg|
  package pkg do
    action :install
  end
end

user node[:icinga][:core][:user] do
  action :create
  comment 'Usuario icinga-core'
  system true
  shell '/bin/false'
  password node[:icinga][:core][:password]
end

group node[:icinga][:core][:group] do
  action :create
  members node[:icinga][:core][:user]
  append true
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node[:icinga][:core][:filename]}.tar.gz" do
  source node[:icinga][:core][:url]
  checksum node[:icinga][:core][:checksum]
  action :create_if_missing
  owner 'root'
  group 'root'
  mode 00644
  not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/#{node[:icinga][:core][:filename]}.tar.gz") }
  notifies :run, 'script[icinga_build]', :immediately
end

script 'icinga_build' do
  interpreter 'bash'
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
          tar xvzf #{node[:icinga][:core][:filename]}.tar.gz;
          cd #{node[:icinga][:core][:filename]};
          ./configure --enable-idoutils --prefix=#{node[:icinga][:core][:path]};
          make all;
          make install;
          make install-config;
          make install-commandmode;
          make install-idoutils;
          make install-init;
       EOH
  not_if "#{node[:icinga][:core][:path]}/bin/icinga --version | grep #{node[:icinga][:core][:version]}"
end

service 'icinga' do
  action :enable
  supports :status => :true, :restart => :true, :reload => :true
end

service 'ido2db' do
  action :enable
  supports :status => :true, :restart => :true, :reload => :true
end

link '/etc/icinga' do
  to "#{node[:icinga][:core][:path]}/etc"
end

if node[:icinga][:auth][:config] == 'AD'

  icinga_pyntlm 'icinga' do
    repo node[:icinga][:auth][:ldap][:gitrepo]
    action :install
  end

else

  node[:icinga][:auth][:local][:users].each_pair do |user, password|
    htpasswd user do
      file node[:icinga][:auth][:local][:file]
      user user
      password password
    end
  end

end

%w(ido2db.cfg idomod.cfg cgi.cfg icinga.cfg).each do |template|
  template "#{node[:icinga][:core][:path]}/etc/#{template}" do
    source "#{template}.erb"
    mode 0644
    owner 'root'
    group 'root'
    notifies :restart, 'service[ido2db]', :delayed
    notifies :restart, 'service[icinga]', :delayed
  end
end

template "#{node[:icinga][:core][:path]}/etc/modules/idoutils.cfg" do
  source 'idoutils.cfg.erb'
  mode 0644
  owner 'root'
  group 'root'
  notifies :restart, 'service[icinga]', :delayed
end

template "#{node[:apache][:dir]}/sites-available/icinga.conf" do
  source 'icinga.conf.erb'
  mode 0644
  owner 'root'
  group 'root'
end

apache_site 'icinga.conf' do
  enable site_enabled
end

mysql_connection_info = {
  :host     => 'localhost',
  :username => 'root',
  :password => node[:mysql][:server_root_password]
}

mysql_database node[:icinga][:core][:db_name] do
  connection mysql_connection_info
  action :create
end

mysql_database_user node[:icinga][:core][:db_user] do
  connection mysql_connection_info
  password node[:icinga][:core][:db_password]
  database_name node[:icinga][:core][:db_name]
  host 'localhost'
  privileges [:all]
  action :grant
end

script 'icinga_schema' do
  interpreter 'bash'
  user 'root'
  group 'root'
  code <<-EOH
          mysql #{node[:icinga][:core][:db_name]} < #{Chef::Config[:file_cache_path]}/#{node[:icinga][:core][:filename]}/module/idoutils/db/mysql/mysql.sql --user=#{node[:icinga][:core][:db_user]} --password=#{node[:icinga][:core][:db_password]}
       EOH
  not_if "mysql --user=#{node[:icinga][:core][:db_user]} --password=#{node[:icinga][:core][:db_password]} icinga -e \"select * from icinga_dbversion\""
  notifies :start, 'service[ido2db]', :immediately
  notifies :start, 'service[icinga]', :immediately
end
