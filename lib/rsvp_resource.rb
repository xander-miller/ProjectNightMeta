class RsvpResource < MeetupResource

  attr_accessor :member_id, :member_name


  def build_with(hash)
    member = hash["member"]
    self.member_name = member["name"]
    self.member_id = member["member_id"]
  end


  protected 
    def self.path
      "/2/rsvps"
    end
end
