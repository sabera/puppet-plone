# Class: plone::site
#
# This module manages plone sites using buildout.
#
# Parameters:
#   name: path to source of buildout
#   group: group to run and own buildout
#   config: which config file to use, defaults to buildout.cfg
#   python: which python executable to use, defaults to system Python
#   refreshonly: whether buildout should be run only on a refresh
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#   class {'plone':
#     enable_ldap => true
#   }
#
# Authors:
#   Mike Wilson, mw@ceh.ac.uk
#
define plone::site(
  $user         = 'plone',
  $group        = 'plone',
  $config       = 'buildout.cfg',
  $python       = '/usr/bin/python',
  $backup       = false,
  $backupname   = undef,
  $refreshonly  = true,
) {
  if ! defined(Class['plone']) {
    fail('You must include the plone base class before using any plone defined resources')
  }

  exec { "${python} ${name}/bootstrap.py":
    cwd     => $name,
    creates => "${name}/bin/buildout",
    user    => $user,
    group   => $group,
  }

  exec { "${name}/bin/buildout -c ${config}":
    cwd         => $name,
    refreshonly => $refreshonly,
    tries       => 2,
    try_sleep   => 10,
    user        => $user,
    group       => $group,
    subscribe   => Exec["${python} ${name}/bootstrap.py"],
    require     => Exec["${python} ${name}/bootstrap.py"],
    timeout     => 0,
  }
  
  if $backup {
    file {"${name}/${backupname}.sh":
      ensure    => file,
      owner     => 'plone',
      group     => 'plone',
      mode      => 0755,
      content   => template('plone/backuptemplate.erb')
    }
  }
}
