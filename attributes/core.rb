# Icinga Core Config
case node[:platform_family]
when 'debian'
  default[:icinga][:core][:packages] = %w(libgd2-xpm-dev libjpeg8 libjpeg8-dev libpng12-0 libpng12-dev libdbi1 libdbi-dev libdbd-mysql snmp libsnmp-dev)
when 'rhel', 'fedora'
  default[:icinga][:core][:packages] = %w(libdbi-devel net-snmp gd gd-devel gcc libdbi-dbd-mysql httpd-devel libdbi libdbi-drivers)
end

# Icinga Core Attributes
default[:icinga][:core][:user] = 'icinga'
default[:icinga][:core][:group] = 'icinga'
default[:icinga][:core][:version] = '1.11.1'
default[:icinga][:core][:filename] = "icinga-#{node[:icinga][:core][:version]}"
default[:icinga][:core][:url] = "https://github.com/Icinga/icinga-core/releases/download/v#{node[:icinga][:core][:version]}/#{node[:icinga][:core][:filename]}.tar.gz"
default[:icinga][:core][:checksum] = '4463b8cf83f13516a7bca30d816e9d90'
default[:icinga][:core][:path] = '/usr/share/icinga'

# Icinga Core Apache conf
default[:icinga][:core][:server_name] = 'icinga'
default[:icinga][:core][:server_alias] = nil

# Icinga Core Mysql Attributes
default[:icinga][:core][:db_name] = 'icinga'
default[:icinga][:core][:db_user] = 'icinga'
default[:icinga][:core][:db_password] = 'password'
