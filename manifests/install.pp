#
# @summary Installs/removes rpms from local file/URL via yum install command.
#
# @note This can be better than using just the rpm provider because it will pull all the dependencies.
#
# @param source file or URL where RPM is available
# @param ensure the desired state of the package
# @param timeout optional timeout for the installation
#
# @example Sample usage:
#   yum::install { 'epel-release':
#     ensure => 'present',
#     source => 'https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm',
#   }
#
define yum::install (
  String                                           $source,
  Enum['present', 'installed', 'absent', 'purged'] $ensure  = 'present',
  Optional[Integer]                                $timeout = undef,
) {
  Exec {
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    environment => 'LC_ALL=C',
  }

  case $ensure {
    'present', 'installed', default: {
      exec { "yum-install-${name}":
        command => "yum -y install '${source}'",
        unless  => "rpm -q '${name}'",
        timeout => $timeout,
      }
    }

    'absent', 'purged': {
      package { $name:
        ensure => $ensure,
      }
    }
  }
}
