#
# Cookbook Name:: icinga
# Provider:: pyntlm
#
# Author:: Mariani Lucas <lmariani@gmail.com>
# Copyright 2014
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
use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :install  do

  package 'python'
  package 'git'

  git "#{Chef::Config[:file_cache_path]}/PyAuthenNTLM2" do
    repository new_resource.repo
    revision 'master'
    action :sync
  end

  cookbook_file 'pyntlm.py' do
    path "#{Chef::Config[:file_cache_path]}/PyAuthenNTLM2/pyntlm.py"
    action :create
  end

  script 'pyntlm_build' do
    interpreter 'bash'
    cwd "#{Chef::Config[:file_cache_path]}/PyAuthenNTLM2"
    user 'root'
    group 'root'
    code <<-EOH
            python setup.py install -f
         EOH
    not_if { ::File.exist?('/usr/lib/python2.6/site-packages/pyntlm.py') }
  end

end
