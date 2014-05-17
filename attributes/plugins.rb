# Nagios Plugins for Icinga config
default[:icinga][:nagios_plg][:version] = '1.5'
default[:icinga][:nagios_plg][:filename] = "nagios-plugins-#{node[:icinga][:nagios_plg][:version]}"
default[:icinga][:nagios_plg][:checksum] = '5d426b0e303a5201073c342d8ddde8bafca1432b'
default[:icinga][:nagios_plg][:url] = "https://www.monitoring-plugins.org/download/#{node[:icinga][:nagios_plg][:filename]}.tar.gz"
