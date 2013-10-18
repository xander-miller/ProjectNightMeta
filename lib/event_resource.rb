class EventResource < MeetupResource

  attr_accessor :id, :name, :event_url, :yes_rsvp_count, :venue, :time,
    :description, :group


  def build_with(hash)
    self.id = hash["id"]
    self.name = hash["name"]
    self.event_url = hash["event_url"]
    self.yes_rsvp_count = hash["yes_rsvp_count"]
    self.venue = hash["venue"]
    self.time = Time.at(hash["time"]/1000)
    self.description = hash["description"]
  end

  def venue_name
    venue["name"]
  end
  def venue_street
    venue["address_1"]
  end
  def venue_city
    venue["city"]
  end

  def rsvps
    @rsvps = RsvpResource.where({event_id: id, rsvp: "yes"}) unless @rsvps
    @rsvps
  end

  def has_rsvp(uid)
    rsvps.detect { | ea | uid == ea.member_id }
  end

  def confirmed_users
    confirms = []
    group.users.each { | user |
      confirms << user if has_rsvp(user.uid)
    }
    confirms
  end

  def unconfirmed_users
    unconfirms = []
    group.users.each { | user |
      unconfirms << user unless has_rsvp(user.uid)
    }
    unconfirms
  end


  protected 
    def self.path
      "/2/events"
    end
end
