
class puppet (
  $disable     = param_lookup('disable', false),
  $disableboot = param_lookup('disableboot', false),
  $environment = param_lookup('environment', ''),
  ){

  $bool_disable=any2bool($disable)
  $bool_disableboot=any2bool($disableboot)

  $manage_service_enable = $puppet::bool_disableboot ? {
    true    => false,
    default => $puppet::bool_disable ? {
      true    => false,
      false   => true,
    },
  }

  $manage_service_ensure = $puppet::bool_disable ? {
    true    => 'stopped',
    default =>  $puppet::bool_absent ? {
      true    => 'stopped',
      default => 'running',
    },
  }

  include puppet::package
  include puppet::service
  include puppet::config

}
