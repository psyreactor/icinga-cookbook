[![Build Status](https://travis-ci.org/psyreactor/icinga-cookbook.svg?branch=master)](https://travis-ci.org/psyreactor/icinga-cookbook)

Icinga Cookbook
===============

#####Install Icinga-core from source code.

>"Icinga is an enterprise grade open source monitoring system which keeps watch over networks and any conceivable network resource, notifies the user of errors and recoveries and generates performance data for reporting. Scalable and extensible, Icinga can monitor complex, large environments across dispersed locations."

#####Install Nagios Plugins from source code.

> "Nagios plugins are standalone extensions to Nagios Core that provide low-level intelligence on how to monitor anything and everything with Nagios Core. Plugins operate as standalone applications, but are generally designed to be executed by Nagios Core."


Requirements
------------
#### Cookbooks:

- apt - https://github.com/opscode-cookbooks/apt
- yum-epel - https://github.com/opscode-cookbooks/yum-epel
- apache2 - https://github.com/onehealth-cookbooks/apache2
- mysql - https://github.com/opscode-cookbooks/mysql
- database - https://github.com/opscode-cookbooks/database
- htpasswd - https://github.com/Youscribe/htpasswd-cookbook


The following platforms and versions are tested and supported using Opscode's test-kitchen.

- Ubuntu 10.04, 12.04
- CentOS 5.8, 6.3
- debian 7.2

The following platform families are supported in the code, and are assumed to work based on the successful testing on Ubuntu and CentOS.

- Debian
- Red Hat (rhel)
- Fedora
- Amazon Linux

Recipes
-------

####Icinga:default
Include Icinga::core
Include Icinga::plugins

####Icinga::core
Install icinga-core from de source code.

####Icinga::plugins
Install Nagios Plugins from de source code.

Attributes
----------
common autentication attributes for all recipes.
#### icinga::default
#####Config Auth
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>node[:icinga][:auth][:config]</tt></td>
    <td>String</td>
    <td>Set Local or AD (Active Directory) for auth </td>
    <td><tt>local</tt></td>
  </tr>
</table>

#####Config Auth Active Directory
Not default attribute set!!
The module for auth Active Directory SSO(Single Sign-On) PyAuthenNTLM2 - https://github.com/Legrandin/PyAuthenNTLM2, the cookbook apply patch for this [issue](https://github.com/Legrandin/PyAuthenNTLM2/issues/12)
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><tt>default[:icinga][:auth][:ldap][:domain]</tt></td>
    <td>String</td>
    <td>Domain Active Directory fqdn</td>
    <td><tt>contoso.com</tt></td>
  </tr>
  <tr>
    <td><tt>default[:icinga][:auth][:ldap][:server1]</tt></td>
    <td>String</td>
    <td>PDC IP or DNS, ldap:// or ldaps://</td>
    <td><tt>ldap://10.0.0.1</tt></td>
  </tr>
  <tr>
    <td><tt>default[:icinga][:auth][:ldap][:server2]</tt></td>
    <td>String</td>
    <td>BDC IP or DNS, ldap:// or ldaps:// (Optional)</td>
    <td><tt>ldap://10.0.0.2</tt></td>
  </tr>
  <tr>
    <td><tt>default[:icinga][:auth][:ldap][:basedn]</tt></td>
    <td>String</td>
    <td>DN Base for search users</td>
    <td><tt>dc=contoso,dc=com</tt></td>
  </tr>
  <tr>
    <td><tt>default[:icinga][:auth][:ldap][:binddn]</tt></td>
    <td>String</td>
    <td>user for bind DN</td>
    <td><tt>adicinga@contoso.com</tt></td>
  </tr>
  <tr>
    <td><tt>default[:icinga][:auth][:ldap][:bindpw]</tt></td>
    <td>String</td>
    <td>password of user for bind DN</td>
    <td><tt>password</tt></td>
  </tr>
  <tr>
    <td><tt>default[:icinga][:auth][:ldap][:groups]</tt></td>
    <td>array</td>
    <td>restricted login Memberof(Optional)</td>
    <td><tt>[admins, operators, monitoring]</tt></td>
  </tr>
  <tr>
    <td><tt>default[:icinga][:auth][:ldap][:admuser]</tt></td>
    <td>array</td>
    <td>Admin users for icinga-core GUI</td>
    <td><tt>[user1, user2, user3]</tt></td>
  </tr>
</table>
#####Config Auth local htapasswd
Local Auth htapasswd apache
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Example</th>
  </tr>
  <tr>
    <td><tt>default[:icinga][:auth][:local][:users]</tt></td>
    <td>Array</td>
    <td>(user => password)</td>
    <td><tt>{ 'user1' => 'pass1', 'user2' => 'pass2', 'user3' => 'pass3' }</tt>    </td>
  </tr>
  <tr>
    <td><tt>default[:icinga][:auth][:local][:file]</tt></td>
    <td>String</td>
    <td>Path for htpassword file</td>
    <td><tt>/etc/icinga/htpasswd.user</tt></td>
  </tr>
  <tr>
    <td><tt>default[:icinga][:auth][:local][:admusr]</tt></td>
    <td>Array</td>
    <td>Admin users for icinga-core GUI</td>
    <td><tt>[user1, user2, user3]</tt></td>
  </tr>
</table>

#### icinga::core
#####Basic config
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>node[:icinga][:core][:user]</tt></td>
    <td>String</td>
    <td>Icinga OS User</td>
    <td><tt>icinga</tt></td>
  </tr>
  <tr>
    <td><tt>node[:icinga][:core][:group]</tt></td>
    <td>String</td>
    <td>Icinga OS Group</td>
    <td><tt>icinga</tt></td>
  </tr>
    <tr>
    <td><tt>node[:icinga][:core][:veriosn]</tt></td>
    <td>String</td>
    <td>Icinga version to install</td>
    <td><tt>1.11.1</tt></td>
  </tr>
  <tr>
    <td><tt>node[:icinga][:core][:filename]</tt></td>
    <td>String</td>
    <td>Icinga filename to download without extension</td>
    <td><tt>"icinga-#{node[:icinga][:core][:version]}"</tt></td>
  </tr>
  <tr>
    <td><tt>node[:icinga][:core][:url]</tt></td>
    <td>String</td>
    <td>Icinga url for download source code</td>
    <td><tt>"https://github.com/Icinga/icinga-core/releases/download/v1.11.1/icinga-11.1.1.tar.gz"</tt></td>
  </tr>
  <tr>
    <td><tt>node[:icinga][:core][:checksum]</tt></td>
    <td>String</td>
    <td>Icinga checksum for download source code</td>
    <td><tt>'4463b8cf83f13516a7bca30d816e9d90'</tt></td>
  </tr>
  <tr>
    <td><tt>node[:icinga][:core][:path]</tt></td>
    <td>String</td>
    <td>Icinga install path</td>
    <td><tt>'/usr/share/icinga'</tt></td>
  </tr>
</table>

#####Apache config for icinga-core
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>node[:icinga][:core][:server_name]</tt></td>
    <td>String</td>
    <td>Server Name apache vhost directive</td>
    <td><tt>icinga</tt></td>
  </tr>
  <tr>
    <td><tt>node[:icinga][:core][:alias]</tt></td>
    <td>String</td>
    <td>Alias apache vhost directive</td>
    <td><tt>nil</tt></td>
  </tr>
</table>

#####Mysql config for icinga-core
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>node[:icinga][:core][:db_user]</tt></td>
    <td>String</td>
    <td>Username for database icinga-core</td>
    <td><tt>icinga</tt></td>
  </tr>
  <tr>  <tr>
    <td><tt>node[:icinga][:core][:db_password]</tt></td>
    <td>String</td>
    <td>password for user of database for icinga-core</td>
    <td><tt>icinga</tt></td>
  </tr>
  <tr>
    <td><tt>node[:icinga][:core][:db_name]</tt></td>
    <td>String</td>
    <td>name of database for icinga-core</td>
    <td><tt>icinga</tt></td>
  </tr>
</table>

####Icinga::plugins
#####Basic config
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>node[:icinga][:nagios_plg][:version]</tt></td>
    <td>String</td>
    <td>Nagios Plugins version to install</td>
    <td><tt>1.5</tt></td>
  </tr>
  <tr>
    <td><tt>node[:icinga][:nagios_plg][:filename]</tt></td>
    <td>String</td>
    <td>Nagios Plugins filename to download without extension</td>
    <td><tt>nagios-plugins-#{node[:icinga][:nagios_plg][:version]}</tt></td>
  </tr>
  <tr>
    <td><tt>node[:icinga][:nagios_plg][:checksum]</tt></td>
    <td>String</td>
    <td>Nagios Plugins checksum for download source code</td>
    <td><tt>5d426b0e303a5201073c342d8ddde8bafca1432b</tt></td>
  </tr>
  <tr>
    <td><tt>node[:icinga][:nagios_plg][:checksum]</tt></td>
    <td>String</td>
    <td>Nagios Plugins url for download source code</td>
    <td><tt>https://www.monitoring-plugins.org/download/#{node[:icinga][:nagios_plg][:filename]}.tar.gz</tt></td>
  </tr>
</table>

Usage
-----
#### icinga::default
Just include `icinga` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[icinga]"
  ]
}
```

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

[More details](https://github.com/psyreactor/icinga-cookbook/blob/master/CONTRIBUTING.md)

License and Authors
-------------------
Authors:
Lucas Mariani (Psyreactor)
- [Gmail](mailto:marianiluca@gmail.com)
- [Github](https://github.com/psyreactor)
