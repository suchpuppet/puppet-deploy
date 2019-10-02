#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'

# Puppet Task Name: generate_types

def generate_types(environment)
  cmd = ['/opt/puppetlabs/puppet/bin/puppet', 'generate', 'types' '--environment', "#{environment}"]

  stdout, stderr, status = Open3.capture3(*cmd) # rubocop:disable Lint/UselessAssignment
  raise Puppet::Error, stderr.strip if status != 0
  { status: stdout.strip }
end

params = JSON.parse(STDIN.read)
environment = params['environment']

begin
  result = generate_types(environment)
  puts JSON.pretty_generate(result)
  exit 0
rescue Puppet::Error => e
  puts JSON.pretty_generate({ status: 'failure', error: e.message })
  exit 1
end
