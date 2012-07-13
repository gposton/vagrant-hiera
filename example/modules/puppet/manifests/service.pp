
class puppet::service {

  service { 'puppet':
    ensure  => $puppet::manage_service_ensure,
    enable  => $puppet::manage_service_enable,
    require => Class['Puppet::Package'],
  }

}
