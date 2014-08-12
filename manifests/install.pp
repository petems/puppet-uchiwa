# == Class uchiwa::install
#
class uchiwa::install {
  case $::osfamily {
    'Debian': {
      class { 'uchiwa::repo::apt': }
      $package_require = Apt::Source['sensu']
    }

    'RedHat': {
      class { 'uchiwa::repo::yum': }
      $package_require = Yumrepo['sensu']
    }

    default: { alert("${::osfamily} not supported yet") }
  }

  if $uchiwa::manage_user {
    user { 'uchiwa':
      ensure  => 'present',
      system  => true,
      home    => '/opt/uchiwa',
      shell   => '/bin/false',
      comment => 'Uchiwa Monitoring Dashboard',
    }

    group { 'uchiwa':
      ensure  => 'present',
      system  => true,
    }
  }

  package { $uchiwa::package_name:
    ensure  => $uchiwa::version,
    require => $package_require,
  }

}
