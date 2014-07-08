# Class: plone
#
# This module manages plone dependencies and includes
# an type to build sites from a buildout source
#
# Parameters:
#   enable_ldap: include packages required for ldap connectivity
#   enable_indexer: include packages required for optional indexing
#
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
class plone (
  $enable_ldap     = false,
  $enable_indexers = false,
  ) {

    # Pillow dependencies based on info supplied by
    #  http://pillow.readthedocs.org/en/latest/installation.html#linux-installation
    case $::osfamily {
      'RedHat': {
        $pillow = [
          'libtiff-devel',
          'libjpeg-turbo-devel',
          'libzip-devel',
          'freetype-devel',
          'lcms2-devel',
          'tcl-devel',
          'tk-devel'
        ]
      }

      'Debian': {
        $pillow = [
          'libtiff4-dev',
          'libjpeg8-dev',
          'zlib1g-dev',
          'libfreetype6-dev',
          'liblcms2-dev',
          'libwebp-dev',
          'tcl8.5-dev',
          'tk8.5-dev',
        ]
      }

      default: {
        fail("Operating system ${::osfamily} is not supported!")
      }
    }

    package { $pillow:
      ensure  => installed,
    }

    # XML libraries required for lxml
    package { 'libxml2-dev':
      ensure  => installed,
    }

    package { 'libxslt1-dev':
      ensure  => installed,
    }

    # Text based browser required for Plone transforms
    package { 'lynx':
      ensure => installed,
    }

    if $enable_indexers {
      # Optional utilities that we use to index Word/PDF docs
      package { 'wv':
        ensure  => installed,
      }

      package { 'poppler-utils':
        ensure => installed,
      }
    }

    if $enable_ldap {
      package { 'libldap2-dev':
        ensure => installed,
      }

      package { 'libsasl2-dev':
        ensure => installed,
      }
    }
}
