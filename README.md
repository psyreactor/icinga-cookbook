icinga Cookbook
===============

This cookbook install Icinga-core from source.

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

####Icinga::core
Install icinga-core from de source code.

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
    <td>Icinga filename to download without extencion</td>
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

License and Authors
-------------------
Authors:
Lucas Mariani (Psyreactor)
- [Gmail](mailto:marianiluca@gmail.com)
- [Github](https://github.com/psyreactor)
