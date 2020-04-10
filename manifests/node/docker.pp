class kubernetes::node::docker (
    $registry_hostnames = ['mrasregistry.i'],

) {
    file {"/etc/docker/certs.d":
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0700'
    }
    $crts = lookup("certs::certs_and_keys", Hash, 'hash')
    $all_crts = merge($crts, $certs_and_keys)
    $registry_hostnames.each  | String $registry_hostname | {
        $crt = $all_crts[$registry_hostname]['ssl_cert']
        file {"/etc/docker/certs.d/${registry_hostname}":
            ensure => directory,
            owner  => 'root',
            group  => 'root',
            mode   => '0700'
        } ->
        file {"/etc/docker/certs.d/${registry_hostname}/ca.crt":
            ensure     => file,
            owner      => 'root',
            group      => 'root',
            mode       => '0400',
            content    => "${crt}\n",
        }
    }
}
