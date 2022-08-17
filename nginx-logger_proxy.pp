include nginx

class{'nginx':
  manage_repo    => true,
  package_source => 'nginx-mainline',
  log_format     => {
    'custom' => '$time_local - "$protocol" "$remote_addr" [$request_time]'
  },
}

nginx::resource::server { 'localhost':
  ensure      => present,
  listen_port => 9090,
  resolver    => '1.1.1.1',
  proxy       => 'http://$http_host$uri$is_args$args',
  format_log  => 'custom',
}
