# Puppet Nginx Module Test
## End goal
Create/extend an existing puppet module for Nginx including the following functionalities:

- Create a proxy to redirect requests for https://domain.com to 10.10.10.10 and redirect requests for https://domain.com/resoure2 to 20.20.20.20.
- Create a forward proxy to log HTTP requests going from the internal network to the Internet including: request protocol, remote IP and time take to serve the request.
- (Optional) Implement a proxy health check.
## Module usage
...
## Resources
- nginx docs: https://nginx.org/en/docs/
- puppet docs: https://puppet.com/docs/
- puppet-nginx repository: https://github.com/voxpupuli/puppet-nginx
