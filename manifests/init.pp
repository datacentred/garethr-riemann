# == Class: riemann
#
# A module to manage riemann, a monitoring system for distributed systems
#
# === Parameters
# [*version*]
#   The version of riemann to instal
#
# [*config_file*]
#   File path for a riemann config file. A default file is provided. If
#   specified you are responsible for ensuring it exists on disk.
#
# [*host*]
#   Host for the riemann server. Used by the puppet report processor.
#
# [*port*]
#   Port for the riemann server. Used by the puppet report processor.
#
# [*user*]
#   The system user which riemann runs as. Defaults to riemann. Will be
#   created by the module.
#
class riemann(
  $version = $riemann::params::version,
  $config_file = $riemann::params::config_file,
  $host = $riemann::params::host,
  $port = $riemann::params::port,
  $user = $riemann::params::user,
  $system_user = $riemann::params::system_user,
  $use_package = $riemann::params::use_package,
) inherits riemann::params {

  validate_absolute_path($config_file)
  validate_string($version, $host, $port)
  validate_bool($use_package)

  class { 'riemann::install': } ->
  class { 'riemann::config': } ~>
  class { 'riemann::service': } ->
  Class['riemann']

}
