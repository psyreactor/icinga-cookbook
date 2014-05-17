# Encoding: utf-8
#
# Cookbook Name:: icinga
# Recipe:: plugins
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

remote_file "#{Chef::Config[:file_cache_path]}/#{node[:icinga][:nagios_plg][:filename]}.tar.gz" do
  source node[:icinga][:nagios_plg][:url]
  checksum node[:icinga][:nagios_plg][:checksum]
  action :create_if_missing
  owner 'root'
  group 'root'
  mode 00644
  not_if { ::File.exist?("#{Chef::Config[:file_cache_path]}/#{node[:icinga][:nagios_plg][:filename]}.tar.gz") }
  notifies :run, 'script[plugins_build]', :immediately
end

script 'plugins_build' do
  interpreter 'bash'
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
          tar xzf #{node[:icinga][:nagios_plg][:filename]}.tar.gz;
          cd #{node[:icinga][:nagios_plg][:filename]};
          ./configure --prefix=#{node[:icinga][:core][:path]} --with-cgiurl=/icinga/cgi-bin --with-nagios-user=#{node[:icinga][:core][:user]} --with-nagios-group=#{node[:icinga][:core][:group]};
          make;
          make install
       EOH
  not_if "#{node[:icinga][:core][:path]}/libexec/check_nagios -V | grep #{node[:icinga][:nagios_plg][:version]}"
end
