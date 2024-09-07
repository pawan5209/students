server '10.0.22.198', user: 'ubuntu', roles: %w{app web db} 

set :ssh_options, {
 keys: %w(~/.ssh/personal_ssh.pem),
 forward_agent: true,
 auth_methods: %w(publickey),
 proxy: Net::SSH::Proxy::Command::new('ssh bastion-host -W %h:%p')
}