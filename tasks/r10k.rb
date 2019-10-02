#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'

# Puppet Task Name: r10k
def r10k(environment, verbose)
  if verbose == true
    flags = '-pv'
  else
    flags = '-p'
  end
  cmd = ['/usr/bin/r10k', 'deploy', 'environment', "#{environment}", "#{flags}"]
  stdout, stderr, status = Open3.capture3(*cmd) # rubocop:disable Lint/UselessAssignment
  raise Puppet::Error, stderr.strip if status != 0
  if stdout.strip.nil? || stdout.strip == ""
    { status: "deployed environment #{environment}"}
  else
    { status: stdout.strip }
  end
end

params = JSON.parse(STDIN.read)
environment = params['environment']

unless params['verbose']
  verbose = false
else
  verbose = params['verbose']
end

begin
  result = r10k(environment, verbose)
  puts JSON.pretty_generate(result)
  exit 0
rescue Puppet::Error => e
  puts JSON.pretty_generate({ status: 'failure', error: e.message })
  exit 1
end
