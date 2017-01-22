class samba::server::users inherits samba::server {
  $samba_users = hiera_array('samba::users', [])
  $users = hiera_hash('users::users', {})
  

  if (is_array($samba_users)) {
    $samba_users.each | $login | {
    if (has_key($users, $login)) {
      $user_params = $users[$login]
      $password = $user_params['password']
      $test = "/bin/bash -c \"! pdbedit -L | grep -q ${login}\""
      $adduser = "echo -ne \"${password}\\n\" | tee - | smbpasswd -a -s ${login}"
      notify{"samba user: ${login}":}
      exec { "smbpasswd add $login":
            command => "/bin/bash -c '${adduser}'",
            path=>'/bin:/usr/bin/:/usr/local/bin',
            onlyif =>  "${test}",
            require => [Class['samba::server::install'], User[$login]],
      }
    }
    }
  }
}