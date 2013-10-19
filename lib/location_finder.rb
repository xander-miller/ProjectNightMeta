class LocationFinder
  attr_accessor :ipaddr

  def self.find_by_ip(ip)
    finder = new
    finder.ipaddr = ip
    location = finder.lookup_freegeoip
    finder.lookup_meetup(location)
  end


  # find location based on @ipaddr
  def lookup_freegeoip
    gate_ip = build_gateway_ip
    client = GeoIpClient.new
    s = client.get_path('/' + gate_ip)
    Location.new_freegeoip( ActiveSupport::JSON.decode(s) )
  end

  # find Meetup location with most members and close to @ipaddr
  def lookup_meetup(location)
    client = RubyMeetup::ApiKeyClient.new
    s = client.get_path('/2/cities', {lat: location.lat, lon: location.lon})
    hash = ActiveSupport::JSON.decode(s)
    Location.new_meetup( hash["results"].first )
  end

  def build_gateway_ip
    ip = ipaddr == '127.0.0.1' ? '66.249.75.176' : ipaddr
    a = ip.split('.')
    a.pop
    a.push('1')
    a.join('.')
  end
end
