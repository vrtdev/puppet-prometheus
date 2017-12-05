# Class: prometheus::alerts
#
# This module manages prometheus alerts for prometheus
#
#  [*location*]
#  Whether to create the alert file for prometheus
#
#  [*alerts*]
#  Array (< prometheus 2.0.0) or Hash (>= prometheus 2.0.0) of alerts (see README).
#
class prometheus::alerts (
  String $location,
  Variant[Array,Hash] $alerts,
  String $alertfile_name  = 'alert.rules'
) inherits prometheus::params {

  if ( versioncmp($::prometheus::version, '2.0.0') < 0 ){

    if $alerts != [] {

      file { "${location}/${alertfile_name}":
        ensure  => 'file',
        owner   => $prometheus::user,
        group   => $prometheus::group,
        notify  => Class['::prometheus::service_reload'],
        content => epp("${module_name}/alerts.epp"),
      }

    }

  }
  else {

    file { "${location}/${alertfile_name}":
      ensure  => 'file',
      owner   => $prometheus::user,
      group   => $prometheus::group,
      notify  => Class['::prometheus::service_reload'],
      content => $alerts.to_yaml,
    }

  }
}
