# Encoding: utf-8

require_relative '../spec_helper'

describe 'icinga::default' do
  let(:chef_run) do
    ChefSpec::Runner.new(
      :platform => 'debian',
      :version => '7.2'
      ) do |node|
      node.set['icinga']['core']['filename'] = 'icinga-core'
    end.converge(described_recipe)
  end

  before do
    stub_command('/usr/share/icinga/bin/icinga --version | grep 1.11.1').and_return(false)
    stub_command("mysql --user=icinga --password=password icinga -e \"select * from icinga_dbversion\"").and_return(false)
  end

  it 'include recipe icinga-core' do
    expect(chef_run).to include_recipe('icinga::core')
  end

end
