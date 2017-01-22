class samba::server::config inherits samba::server {
   include samba::server::install
   include samba::server::restart
  
  $smb_conf_tpl = 'samba/server/smb.conf.noad.erb'
  
  file { '/etc/samba/smb.conf':
    ensure => file,
    mode => '0644',
    owner => 'root',
    group => 'root',
    content => template($smb_conf_tpl),
    require => Class['samba::server::install'],
    notify => Exec['service smbd restart'],
  }

  file { '/etc/samba/shares':
    ensure => 'directory',
    mode => '0755',
    owner => 'root',
    group => 'root',
  }
}
