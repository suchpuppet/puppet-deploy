#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'

# Puppet Task Name: generate_types

def generate_types(environment)
  cmd = ['/opt/puppetlabs/puppet/bin/puppet', 'generate', 'types', '--environment', "#{environment}"]

  stdout, stderr, status = Open3.capture3(*cmd) # rubocop:disable Lint/UselessAssignment
  raise Puppet::Error, stderr.strip.gsub(/\e\[([;\d]+)?m/, '') if status != 0
  if verbose == true
    if stdout.strip.nil? || stdout.strip == ""
      { status: "success" }
    else
      { status: stdout.strip.gsub(/\e\[([;\d]+)?m/, '') }
    end
  else
    { status: "success" }
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
  result = generate_types(environment, verbose)
  puts JSON.pretty_generate(result)
  exit 0
rescue Puppet::Error => e
  puts JSON.pretty_generate({ status: 'failure', error: e.message })
  exit 1
end
