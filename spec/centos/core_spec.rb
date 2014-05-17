# Encoding: utf-8

require_relative '../spec_helper'

describe 'icinga::core' do
  let(:chef_run) do
    ChefSpec::Runner.new(
      :platform => 'centos',
      :version => '6.5'
      ) do |node|
      node.set[:icinga][:core][:user] = 'icinga'
      node.set[:icinga][:core][:group] = 'icinga'
      node.set[:icinga][:core][:version] = '1.11.1'
      node.set[:icinga][:core][:filename] = 'icinga-1.11.1'
      node.set[:icinga][:core][:db_user] = 'icinga'
      node.set[:icinga][:core][:db_password] = 'password'
      node.set[:icinga][:core][:db_db_name] = 'icinga'
      node.set[:icinga][:auth][:config] = 'local'
    end.converge(described_recipe)
  end

  let(:file_icinga_core) { chef_run.remote_file("#{Chef::Config[:file_cache_path]}/icinga-1.11.1.tar.gz") }
  let(:template_ido2db) { chef_run.template('/usr/share/icinga/etc/ido2db.cfg') }
  let(:template_idomod) { chef_run.template('/usr/share/icinga/etc/idomod.cfg') }
  let(:template_cgi) { chef_run.template('/usr/share/icinga/etc/cgi.cfg') }
  let(:template_icinga) { chef_run.template('/usr/share/icinga/etc/icinga.cfg') }
  let(:template_idoutils) { chef_run.template('/usr/share/icinga/etc/modules/idoutils.cfg') }
  let(:script_icinga_schema) { chef_run.script('icinga_schema') }

  before do
    stub_command('/usr/share/icinga/bin/icinga --version | grep 1.11.1').and_return(false)
    stub_command("mysql --user=icinga --password=password icinga -e \"select * from icinga_dbversion\"").and_return(false)
  end

  it 'include recipe yum-epel' do
    expect(chef_run).to include_recipe('yum-epel::default')
  end

  it 'include recipe apache2' do
    expect(chef_run).to include_recipe('apache2::default')
    expect(chef_run).to include_recipe('apache2::mod_rewrite')
    expect(chef_run).to include_recipe('apache2::mod_dir')
    expect(chef_run).to include_recipe('apache2::mod_cgi')
  end

  it 'include recipe mysql' do
    expect(chef_run).to include_recipe('mysql::server')
  end

  it 'include recipe database' do
    expect(chef_run).to include_recipe('database::mysql')
  end

  it 'install packages required for icinga core' do
    expect(chef_run).to install_package('libdbi-drivers')
    expect(chef_run).to install_package('libdbi')
    expect(chef_run).to install_package('httpd-devel')
    expect(chef_run).to install_package('gcc')
    expect(chef_run).to install_package('gd-devel')
    expect(chef_run).to install_package('gd')
    expect(chef_run).to install_package('net-snmp')
    expect(chef_run).to install_package('libdbi-devel')
  end

  it 'creates a user icinga' do
    expect(chef_run).to create_user('icinga')
    expect(chef_run).to create_group('icinga')
  end

  it 'download a icinga-core source' do
    expect(chef_run).to create_remote_file_if_missing("#{Chef::Config[:file_cache_path]}/icinga-1.11.1.tar.gz")
  end

  it 'runs a bash script for icinga build' do
    expect(chef_run).to run_script('icinga_build')
  end

  it 'sends a notification to bash icinga_build' do
    expect(file_icinga_core).to notify('script[icinga_build]').immediately
  end

  it 'declare service icinga' do
    expect(chef_run).to enable_service('icinga')
  end

  it 'declare service ido2db' do
    expect(chef_run).to enable_service('ido2db')
  end

  it 'create symbolic link to etc' do
    expect(chef_run).to create_link('/etc/icinga')
  end

  it 'install PyAuthNTLM2' do
    expect(chef_run).to_not install_icinga_pyntlm('icinga')
  end

  it 'create ido2db.cfg file' do
    expect(chef_run).to create_template('/usr/share/icinga/etc/ido2db.cfg')
  end

  it 'sends a notification to services' do
    expect(template_ido2db).to notify('service[ido2db]').to(:restart).delayed
    expect(template_ido2db).to notify('service[icinga]').to(:restart).delayed
  end

  it 'create idomod.cfg file' do
    expect(chef_run).to create_template('/usr/share/icinga/etc/idomod.cfg')
  end

  it 'sends a notification to services' do
    expect(template_idomod).to notify('service[ido2db]').to(:restart).delayed
    expect(template_idomod).to notify('service[icinga]').to(:restart).delayed
  end

  it 'create cgi.cfg file' do
    expect(chef_run).to create_template('/usr/share/icinga/etc/cgi.cfg')
  end

  it 'sends a notification to services' do
    expect(template_cgi).to notify('service[ido2db]').to(:restart).delayed
    expect(template_cgi).to notify('service[icinga]').to(:restart).delayed
  end

  it 'create icinga.cfg file' do
    expect(chef_run).to create_template('/usr/share/icinga/etc/icinga.cfg')
  end

  it 'sends a notification to services' do
    expect(template_icinga).to notify('service[ido2db]').to(:restart).delayed
    expect(template_icinga).to notify('service[icinga]').to(:restart).delayed
  end

  it 'create idoutils.cfg file' do
    expect(chef_run).to create_template('/usr/share/icinga/etc/modules/idoutils.cfg')
  end

  it 'sends a notification to services' do
    expect(template_idoutils).to notify('service[icinga]').to(:restart).delayed
  end

  it 'create icinga apache site' do
    expect(chef_run).to create_template('/etc/httpd/sites-available/icinga.conf')
  end

  it 'create database icinga' do
    expect(chef_run).to create_mysql_database('icinga')
  end

  it 'create user for database icinga' do
    expect(chef_run).to grant_mysql_database_user('icinga')
  end

  it 'runs a bash script for icinga schema import' do
    expect(chef_run).to run_script('icinga_schema')
  end

  it 'sends a notification to services' do
    expect(script_icinga_schema).to notify('service[icinga]').to(:start).immediately
    expect(script_icinga_schema).to notify('service[ido2db]').to(:start).immediately
  end

end
