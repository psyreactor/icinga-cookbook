# Encoding: utf-8

require_relative 'spec_helper'

describe user('icinga') do
  it { should exist }
  it { should belong_to_group 'icinga' }
end

os = property[:os][:family]
%w(libdbi-devel net-snmp gd gd-devel gcc libdbi-dbd-mysql httpd-devel libdbi libdbi-drivers).each do |pkg|
  describe package(pkg), :if => os == 'RedHat' do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end
end

%w(libgd2-xpm-dev libjpeg8 libjpeg8-dev libpng12-0 libpng12-dev libdbi1 libdbi-dev libdbd-mysql snmp libsnmp-dev).each do |pkg|
  describe package(pkg), :if => os == 'Ubuntu' || os == 'Debian' do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end
end

describe file('/tmp/kitchen/cache/icinga-1.11.1.tar.gz') do
  it { should be_file }
end

describe file('/etc/icinga/htpasswd.user') do
  it { should be_file }
end

describe file('/usr/share/icinga/etc/ido2db.cfg') do
  it { should be_file }
end

describe file('/usr/share/icinga/etc/idomod.cfg') do
  it { should be_file }
end

describe file('/usr/share/icinga/etc/cgi.cfg') do
  it { should be_file }
end

describe file('/usr/share/icinga/etc/modules/idoutils.cfg') do
  it { should be_file }
end

describe file('/etc/httpd/sites-available/icinga.conf'),:if => os == 'RedHat' do
  it { should be_file }
end

describe file('/etc/apache2/sites-available/icinga.conf'),:if => os == 'Ubuntu' || os == 'Debian' do
  it { should be_file }
end

describe file('/etc/httpd/sites-enabled/icinga.conf'),:if => os == 'RedHat' do
  it { should be_linked_to '/etc/httpd/sites-available/icinga.conf' }
end

describe file('/etc/apache2/sites-enabled/icinga.conf'),:if => os == 'Ubuntu' || os == 'Debian' do
  it { should be_file }
end

describe file('/etc/icinga') do
  it { should be_linked_to '/usr/share/icinga/etc' }
end

describe command('mysql --user=icinga --password=password icinga -e "select * from icinga_dbversion" | grep 1.11.0 -ci') do
  it { should return_stdout '1' }
end
