class samba::server::shares  inherits samba::server {
  include samba::server::restart

  $shares = hiera_hash('samba::shares', {})

  if (is_hash($shares)) {
    $shares.each | $title, $params  | {

      $path = has_key($params, 'path') ? { true => $params[path], false => $title }
      $writeable = has_key($params, 'writeable') ? { true => $params[writeable], false => false }
      $browsable = has_key($params , 'browsable') ? { true => $params[browsable], false => true }
      $valid_users = $params[valid_users]
      #$mask = has_key($params, 'mask') ? {true => $params[mask], false => '0755'}
      #$mode = has_key($params, 'mode') ? {true => $params[mode], false => '0644'}
      $force_group = has_key($params, 'force_group') ? {true => $params[force_group], false => undef}

      $directory_mask = has_key($params, 'directory_mask') ? {true => $params[directory_mask], false => '2750'}
      #$directory_security_mask = has_key($params, 'directory_security_mask') ? {true => $params[directory_security_mask], false => '0770'}
      #$force_directory_security_mode = has_key($params, 'force_directory_security_mode') ? {true => $params[force_directory_security_mode], false => '2700'}
      
      $create_mask = has_key($params, 'create_mask') ? {true => $params[create_mask], false => '0640'}
      #$security_mask = has_key($params, 'security_mask') ? {true => $params[security_mask], false => '0660'}
      #$force_security_mode  = has_key($params, 'force_security_mode') ? {true => $params[force_security_mode], false => '0600'}
      
      $inherit_acls  = has_key($params, 'inherit_acls') ? {true => $params[inherit_acls], false => true}

      $share_conf = "/etc/samba/shares/${title}.conf"
      
      file { $share_conf:
        ensure => file,
        mode => '0644',
        owner => 'root',
        group => 'root',
        content => template('samba/server/shares/default.erb'),
        notify => Class['samba::server::restart'],
      } 
      file_line { $share_conf:
        path => '/etc/samba/shares.conf',
        line => "include = ${share_conf}",
        require => File['/etc/samba/shares'],
        notify => Class['samba::server::restart'],
      }
    }
  }



  file { '/etc/samba/shares.conf':
    ensure => file,
    mode => '0644',
    owner => 'root',
    group => 'root',
    content => template('samba/server/shares.erb'),
    notify => Class['samba::server::restart'],
    require => Class['samba::server::config'],
  }

}
