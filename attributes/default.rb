# Common Auth config
default[:icinga][:auth][:config] = 'local' # Valores validos AD o local

# Active Directory config
default[:icinga][:auth][:ldap][:domain] = 'contoso.com'
default[:icinga][:auth][:ldap][:server1] = 'ldap://192.168.0.1'
default[:icinga][:auth][:ldap][:server2] = 'ldap://192.168.0.2'
default[:icinga][:auth][:ldap][:basedn] = 'DC=contoso,DC=com'
default[:icinga][:auth][:ldap][:binddn] = 'icingaad@contoso.com'
default[:icinga][:auth][:ldap][:bindpw] = 'icinga'
default[:icinga][:auth][:ldap][:pdc] = "#{node[:icinga][:auth][:ldap][:server1]}/#{node[:icinga][:auth][:ldap][:basedn]}"
default[:icinga][:auth][:ldap][:bdc] = "#{node[:icinga][:auth][:ldap][:server2]}/#{node[:icinga][:auth][:ldap][:basedn]}"
default[:icinga][:auth][:ldap][:groups] = %w(group1 group2)
default[:icinga][:auth][:ldap][:gitrepo] = 'https://github.com/Legrandin/PyAuthenNTLM2.git'
default[:icinga][:auth][:ldap][:admusr] =  %w(user1 user2 user3)

# Local Auth config
default[:icinga][:auth][:local][:users] = { 'user1' => 'pass1', 'user2' => 'pass2', 'user3' => 'pass3' }
default[:icinga][:auth][:local][:file] = '/etc/icinga/htpasswd.user'
default[:icinga][:auth][:local][:admusr] = %w(user1 user3)

# Admins Users
if node[:icinga][:auth][:config] == 'AD'
  node[:icinga][:auth][:ldap][:admusr].each do |usr|
    default[:icinga][:auth][:admusr] =	"#{node[:icinga][:auth][:admusr]},#{usr}"
  end
else
  node[:icinga][:auth][:local][:admusr].each do |usr|
    default[:icinga][:auth][:admusr] =	"#{node[:icinga][:auth][:admusr]},#{usr}"
  end
end

default[:icinga][:auth][:admusr] = "icingaadmin#{node[:icinga][:auth][:admusr]}"
