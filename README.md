# Puppet Nginx Module Test
## End goals
Create/extend an existing puppet module for Nginx including the following functionalities:

- [X] Create a proxy to redirect requests for https://domain.com to 10.10.10.10 and redirect requests for https://domain.com/resoure2 to 20.20.20.20.
- [X] Create a forward proxy to log HTTP requests going from the internal network to the Internet including: request protocol, remote IP and time take to serve the request.
- [ ] (Optional) Implement a proxy health check.
## Module usage
Each of the tasks have been defined on a separate file, so they can be included individually when defining a node configuration.

First, install the module we're using as [base](https://github.com/voxpupuli/puppet-nginx):

    puppet module install puppet-nginx

After that, define the node we'll work with. In this case, `internal.domain.com`:

    node 'internal.domain.com' {

        # Define nginx class, and include custom log formatting
        class{'nginx':
            manage_repo    => true,
            package_source => 'nginx-stable',
            log_format     => {
                'custom' => '$time_local - "$protocol" "$remote_addr" [$request_time]'
            },
        }

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
            health   => true,
            proxy       => 'http://internal_domain_com'
        }

        nginx::resource::location { '/resoure2':
            ensure   => present,
            ssl      => true,
            location => '~ "^/resoure2/(.*)"',
            server   => 'domain.com',
            proxy    => 'http://20.20.20.20',
        }

        nginx::resource::server { 'localhost':
            ensure      => present,
            listen_port => 9090,
            resolver    => ['1.1.1.1'],
            proxy       => 'http://$http_host$uri$is_args$args',
            format_log  => 'custom',
        }

    }

Once everything is ready, Puppet can be triggered using the target's CLI, and running the following:

    puppet agent -t

## Resources
- nginx docs: https://nginx.org/en/docs/
- puppet docs: https://puppet.com/docs/
- puppet-nginx repository: https://github.com/voxpupuli/puppet-nginx
- puppet learning vm: https://puppet.com/try-puppet/puppet-learning-vm/
