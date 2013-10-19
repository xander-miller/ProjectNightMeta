class GeoIpClient < RubyMeetup::Client

  protected
    # :nodoc:
    def new_uri
      URI("http://freegeoip.net/json" + path)   # path = '/0.0.0.0'
    end
end
