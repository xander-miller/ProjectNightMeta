class Location
  attr_accessor :city, :region, :country, :lat, :lon

  def self.new_freegeoip(hash={})
    location = new
    location.city = hash["city"]
    location.region = hash["region_code"]
    location.country = hash["country_code"]
    location.lat = hash["latitude"]
    location.lon = hash["longitude"]
    location
  end

  def self.new_meetup(hash={})
    location = new
    location.city = hash["city"]
    location.region = hash["state"].upcase
    location.country = hash["country"].upcase
    location.lat = hash["lat"]
    location.lon = hash["lon"]
    location
  end

  def self.new_session(hash={})
    location = new
    location.city = hash[:ip_city]
    location.region = hash[:ip_region]
    location.country = hash[:ip_country]
    location
  end


  def to_s
    s = ""
    s << (city + ", ") unless city.blank?
    s << (region + ", ") unless region.blank?
    s << country
    s
  end
end
