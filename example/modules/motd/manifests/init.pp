class motd {
  file { '/etc/motd':
    #    content => function_hiera('motd')
    content => param_lookup('motd')
  }
}
