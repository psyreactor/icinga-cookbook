# Encoding: utf-8

require_relative '../spec_helper'

describe 'icinga::plugins' do
  let(:chef_run) do
    ChefSpec::Runner.new(
      :platform => 'debian',
      :version => '7.2'
      ) do |node|
      node.set[:icinga][:nagios_plg][:version] = '1.5'
      node.set[:icinga][:nagios_plg][:filename] = 'nagios-plugins-1.5'
      node.set[:icinga][:nagios_plg][:checksum] = '5d426b0e303a5201073c342d8ddde8bafca1432b'
    end.converge(described_recipe)
  end

  let(:file_plugins) { chef_run.remote_file("#{Chef::Config[:file_cache_path]}/nagios-plugins-1.5.tar.gz") }

  before do
    stub_command('/usr/share/icinga/libexec/check_nagios -V | grep 1.5').and_return(false)
  end

  it 'download a nagios-plugins source' do
    expect(chef_run).to create_remote_file_if_missing("#{Chef::Config[:file_cache_path]}/nagios-plugins-1.5.tar.gz")
  end

  it 'sends a notification to bash plugins_build' do
    expect(file_plugins).to notify('script[plugins_build]').immediately
  end

  it 'runs a bash script for plugins build' do
    expect(chef_run).to run_script('plugins_build')
  end

end
