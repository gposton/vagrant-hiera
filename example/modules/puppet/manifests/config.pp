
class puppet::config {

  Augeas {
    require => Class['Puppet::Package'],
  }

  $autostart = $puppet::bool_disableboot ? {
    true  => 'no',
    false => 'yes',
  }

  augeas { 'auto start puppet':
    context => '/files/etc/default/puppet',
    changes => "set START ${autostart}",
    notify  => Class['Puppet::Service'],
  }

  # Puppet's default environment is production, therefore if no
  # environment is set, it will assume production.  The default
  # value for this variable is '', so the code below will have
  # the following effect:
  # If the puppet::environment param is set, use that.
  #
  # Else do not update what is currently in puppet.conf
  #
  # If nothing is currently in puppet.conf and the param is also
  # not set, use production
  if $puppet::environment != '' {
    augeas { 'set env':
      context => '/files/etc/puppet/puppet.conf',
      changes => [
        "set main/environment ${puppet::environment}",
      ],
    }
  }

  augeas { 'puppet.conf':
    context => '/files/etc/puppet/puppet.conf',
    changes => [
      'set main/server puppet.colo',
      'set main/ca_server puppetca.colo',
      'set main/pluginsync true',
      'set inspect/archive_files true',
      'set inspect/archive_file_server puppet.colo',
      'set agent/splay true'
    ],
  }

}
