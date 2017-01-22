class samba::server (
  $is_ads = $samba::server::params::is_ads,
  $with_winbind  = $samba::server::params::with_winbind,
  $is_join = $samba::server::params::is_join,
  $install_options = undef,
  $release = undef,
) inherits samba::server::params {

  $r_is_ads = $is_ads

  $r_with_winbind = $is_ads ? {
    false => false,
    true => $with_winbind
  }
  $r_is_join = $r_with_winbind ? {
    false => false,
    true => $is_join,
  }

  if ($release == undef) {
    $r_release = $::osfamily ? {
      'Debian' => "stretch"
    }
  }
  

  if ($install_options == undef) {
    $r_install_options = $::osfamily ? {
      'Debian' => {'--target-release'=>$r_release},
    } 
  } else {
    $r_install_options = undef
  }

  contain 'samba::server::install'
  contain 'samba::server::config'
  contain 'samba::server::users'
  contain 'samba::server::shares'
}
