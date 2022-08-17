nginx::resource::server { 'localhost':
  ensure      => present,
  listen_port => 9090,
  resolver    => ['1.1.1.1'],
  proxy       => 'http://$http_host$uri$is_args$args',
  format_log  => 'custom',
}
