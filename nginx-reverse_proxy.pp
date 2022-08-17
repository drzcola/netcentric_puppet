include nginx

nginx::resource::upstream {'internal_domain_com':
  ensure  => present,
  members => {
    '10.10.10.10' => {
      server => '10.10.10.10',
      port   => 80,
      weight => 1,
    },
  },
}

nginx::resource::server { 'domain.com':
  ensure      => present,
  ssl         => true,
  ssl_cert    => '/path/to/cert',
  ssl_key     => '/path/to/key',
  listen_port => 80,
  proxy       => 'http://internal_domain_com'
}

nginx::resource::location { '/resoure2':
  ensure   => present,
  ssl      => true,
  location => '~ "^/resoure2/(.*)',
  server   => 'domain.com',
  proxy    => 'http://20.20.20.20'
}
