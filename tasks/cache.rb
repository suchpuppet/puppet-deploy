#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'net/https'
require 'facter'
require 'puppet'

# Puppet Task Name: deploy::cache #

def clear_cache(fqdn, environment, endpoint)
  ssl_dir = "/etc/puppetlabs/puppet/ssl"
  cert_file = "#{ssl_dir}/certs/#{fqdn}.pem"
  key_file = "#{ssl_dir}/private_keys/#{fqdn}.pem"
  ca_file = "#{ssl_dir}/certs/ca.pem"

  cert = OpenSSL::X509::Certificate.new(File.read(cert_file))
  key = OpenSSL::PKey::RSA.new(File.read(key_file))

  uri = URI("https://#{fqdn}:8140/#{endpoint}?environment=#{environment}")

  Net::HTTP.start(uri.host, uri.port, use_ssl: true, ca_file: ca_file, cert: cert, key: key) do |http|
    request = Net::HTTP::Delete.new("#{uri.path}?#{uri.query}")
    response = http.request(request)

    if response.code == "204"
      { status: 'success' }
    else
      raise Puppet::Error, "API returned #{response.code}"
    end
  end
end

params = JSON.parse(STDIN.read)
fqdn = Facter.value(:fqdn)
endpoint = "puppet-admin-api/v1/environment-cache"

begin
  result = clear_cache(fqdn, params['environment'], endpoint)
  puts JSON.pretty_generate(result)
  exit 0
rescue Puppet::Error => e
  puts JSON.pretty_generate({ status: 'failure', error: e.message })
  exit 1
end
