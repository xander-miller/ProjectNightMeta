ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def new_user_hash
    # source: https://github.com/tapster/omniauth-meetup
    {
      "provider"=>"meetup",
      "uid"=>12345,
      "info"=> {
        "id"=>111,
        "name"=>"elvis",
        "photo_url"=>"http://photos3.meetupstatic.com/photos/member_pic_111.jpeg"
        },
      "credentials"=> {
          "token"=>"abc123...",         # OAuth 2.0 access_token, which you may wish to store
          "refresh_token"=>"bcd234...", # This token can be used to refresh your access_token later
          "expires_at"=>1324720198,     # when the access token expires (Meetup tokens expire in 1 hour)
          "expires"=>true
        },
      "extra"=> {
        "raw_info"=> {
          "lon"=>-90.027181,
          "link"=>"http://www.meetup.com/members/111",
          "lang"=>"en_US",
          "photo"=> {
            "photo_link"=> "http://photos3.meetupstatic.com/photos/member_pic_111.jpeg",
            "highres_link"=> "http://photos1.meetupstatic.com/photos/member_pic_111_hires.jpeg",
            "thumb_link"=> "http://photos1.meetupstatic.com/photos/member_pic_111_thumb.jpeg",
            "photo_id"=>111
          },
          "city"=>"Memphis",
          "country"=>"us",
          "visited"=>1325001005000,
          "id"=>111,
          "topics"=>[],
          "joined"=>1147652858000,
          "name"=>"elvis",
          "other_services"=> {"twitter"=>{"identifier"=>"@elvis"}},
          "lat"=>35.046677
        }
      }
    }
  end

end
