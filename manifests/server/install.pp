class samba::server::install inherits samba::server {
    include samba::server::repository

    package { 'samba':
      ensure  => latest,
      require => Class['samba::server::repository'],
      install_options => $r_install_options,
      notify => Class['samba::server::config']
    }

#    package { 'libpam-smbpass':
#      ensure  => latest,
#      require => Package['samba'],
#      install_options => $r_install_options,
#    }

     service { 'smbd':
      ensure  => true,
      enable => true,
      require => Package['samba'],
    }
}