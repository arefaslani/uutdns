require 'optparse'
require 'uutdns'
require 'socket'

class Application
  def self.run()
    $type = :standard
    $ip
    $domain
    $server = "127.0.0.1"
    $port = 53

    # Parse command line optoions
    OptionParser.new do |opts|
      opts.banner = "A simple DNS client built in Ruby written by Aref Aslani"
      opts.separator "options:"

      opts.on("--ip IP",
              "Gets the IP address as argument and returns domain name") do |ip|
        $type = :inverse
        $ip = ip
      end

      opts.on("--domain DOMAIN",
              "Gets the DOMAIN as argument and returens the IP address") do |domain|
        $type = :standard
        $domain = domain
      end

      opts.on("--server SERVER",
              "Gets DNS server ip address(default value is 127.0.0.1)") do |server|
        $server = server
      end

      opts.on("--port PORT",
              "Gets DNS server port number(default value is 53)") do |port|
        $port = port
      end
    end.parse!

    dns = UUTDNS.new
    dns_msg = ''

    case $type
    when :standard
      dns_msg = dns.header($type) + dns.question($domain)
    when :inverse
      puts "Inverse lookup not implemented yet."
      exit
    end

    ds = UDPSocket.new(:INET)
    ds.connect($server, $port)
    ds.send(dns_msg, 0)
    
    begin
      response, address = ds.recvfrom(1024)
    rescue Errno::ECONNREFUSED
      puts "Connection refused by the server."
      exit
    end

    puts "The DNS header for the domain \"#{$domain}\" is: " + dns.header($type)
    puts "The DNS question part for the domain \"#{$domain}\" is: " + dns.question($domain)

    puts "The server response is:"
    p response 
  end
end