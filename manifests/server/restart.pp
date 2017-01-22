class samba::server::restart inherits samba::server {
    exec { 'service smbd restart':
      user=>'root',
	  group=>'root',
	  path=>'/bin:/usr/bin:/usr/sbin:/usr/local/bin',
	  refreshonly => true,
    }
}
