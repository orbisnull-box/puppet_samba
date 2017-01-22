class samba::server::repository inherits samba::server {
   apt::pin { 'apt_samba_testing':
    packages => 'samba samba-* libsmbclient libpam-smbpass',
    codename => 'stretch',
    priority => 1000,
    order => 40,
  }
}
