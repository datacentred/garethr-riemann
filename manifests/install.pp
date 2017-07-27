class riemann::install {
  include wget
  include java
 

  if $riemann::use_package == false { 
    case $::osfamily {
      'RedHat', 'Amazon': {
        ensure_resource('package', 'daemonize', {'ensure' => 'present' })
      }
      default: {}
    }
  
    wget::fetch { 'download_riemann':
      source      => "https://github.com/riemann/riemann/releases/download/${riemann::version}/riemann-${riemann::version}.tar.bz2",
      destination => "/usr/local/src/riemann-${riemann::version}.tar.bz2",
      before      => Exec['untar_riemann'],
    }
  
    file { '/opt/riemann':
      ensure  => link,
      target  => "/opt/riemann-${riemann::version}",
      owner   => $riemann::user,
      require => User[$riemann::user],
    }
  
    user { $riemann::user:
      ensure => present,
      system => $riemann::system_user,
    }
  
    file { "/opt/riemann-${riemann::version}":
      ensure  => directory,
      owner   => $riemann::user,
      require => User[$riemann::user],
    }
  
    exec { 'untar_riemann':
      command => "/bin/tar --bzip2 -xvf /usr/local/src/riemann-${riemann::version}.tar.bz2",
      cwd     => '/opt',
      creates => "/opt/riemann-${riemann::version}/bin/riemann",
      before  => File['/opt/riemann'],
      user    => $riemann::user,
      require => File["/opt/riemann-${riemann::version}"],
    }

  } else {
    case $::osfamily {
      'RedHat', 'Amazon': {
        $_pkg_name = "riemann-${riemann::version}-1.noarch.rpm" 
        $_pkg_type = "rpm" 
      }
      'Debian': {
        $_pkg_name =  "riemann_${riemann::version}_all.deb"  
        $_pkg_type = "dpkg" 
      }
      default: {}
    }

    wget::fetch { 'download_riemann_package':
      source      => "https://github.com/riemann/riemann/releases/download/${riemann::version}/${_pkg_name}",
      destination => "/usr/local/src/${_pkg_name}",
    } ->

    package { 'riemann':
      source => "/usr/local/src/${_pkg_name}",
      provider => $_pkg_type,
    }
  }

}
