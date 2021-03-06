class riemann::params {
  $version = '0.2.4'
  $config_file = '/etc/riemann.sample.config'
  $dash_port = 4567
  $dash_host = 'localhost'
  $dash_user = 'riemann-dash'
  $net_user = 'riemann-net'
  $health_user = 'riemann-health'
  $port = '5555'
  $host = 'localhost'
  $user = 'riemann'
  $rvm_ruby_string = undef
  $system_user = false
  $use_package = false 

  case $::osfamily {
    'Debian': {
      if versioncmp($::operatingsystemrelease, '8.0') >= 0 { 
        $service_provider = 'systemd'
      }
      else {
        $service_provider = 'upstart'
      }
      $libxml_package = 'libxml2-dev'
      $libxslt_package = 'libxslt1-dev'
    }
    'Ubuntu': {
      if versioncmp($::operatingsystemrelease, '15.04') >= 0 {
        $service_provider = 'systemd'
      }
      else {
        $service_provider = 'upstart'
      }
    }
    'RedHat', 'Amazon': {
      include epel
      $service_provider = redhat
      $libxml_package = 'libxml2-devel'
      $libxslt_package = 'libxslt-devel'
      $gem_path = $::operatingsystemrelease ? {
        '5.8'   => '/usr/local/bin/',
        default => '/usr/bin/',
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }

}
