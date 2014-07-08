# Plone Module

This is the [Plone](https://plone.org/) puppet module, it installs system wide package dependencies required to run [Plone](https://plone.org/).  It can also be used to create an instance of a site using buildout.

## Usage

Just install dependencies,
```puppet
  class {'plone':
    enable_ldap => true,
  }
```

Create an instance of a site using buildout, the folder should have a valid [buildout structure](http://www.buildout.org/en/latest/docs/dirstruct.html) including `bootstrap.py`
```puppet
  plone::site {'/home/plone/site':}
```
This will default to running the `bootstrap.py` file prior to `buildout` using `buildout.cfg`
