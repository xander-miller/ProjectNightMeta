class MeetupResource

  def self.where(options={})
    s = client.get_path(path, options)
    hash = ActiveSupport::JSON.decode(s)
    all_new_with(hash["results"])
  end

  def self.all_new_with(array)
    array.collect { | hash | new_with(hash) }
  end

  def self.new_with(hash)
    res = new
    res.build_with(hash)
    res
  end


  def build_with(hash)
    raise "Subclass should implement"
  end


  protected
    def self.client
      RubyMeetup::ApiKeyClient.new
    end
 
    def self.path
      raise "Subclass should implement"
    end
end
