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
        "id"=>12345,
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
          "state" => "TN",
          "country"=>"us",
          "visited"=>1325001005000,
          "id"=>12345,
          "topics"=>[],
          "joined"=>1147652858000,
          "name"=>"elvis",
          "other_services"=> {"twitter"=>{"identifier"=>"@elvis"}},
          "lat"=>35.046677
        }
      }
    }
  end

  def new_group_hash
    # source: http://www.meetup.com/meetup_api/docs/2/groups/
    #   GET https://api.meetup.com/2/groups?&sign=true&member_id=111
    json_s = '{
      "results": [
        {
          "lon": -75.69000244140625,
          "visibility": "public",
          "organizer": {
            "name": "Edward Ocampo-Gooding",
            "member_id": 9402939
          },
          "link": "http://www.meetup.com/OttawaRuby/",
          "state": "ON",
          "join_mode": "open",
          "who": "Ruby Ninjas",
          "country": "CA",
          "city": "Ottawa",
          "id": 1523801,
          "category": {
            "id": 34,
            "name": "tech",
            "shortname": "tech"
          },
          "topics": [
            {
              "id": 563,
              "urlkey": "opensource",
              "name": "Open Source"
            },
            {
              "id": 1040,
              "urlkey": "ruby",
              "name": "Ruby"
            }
          ],
          "timezone": "Canada/Eastern",
          "group_photo": {
            "photo_link": "http://photos1.meetupstatic.com/photos/event/d/9/e/6/600_274375782.jpeg",
            "highres_link": "http://photos1.meetupstatic.com/photos/event/d/9/e/6/highres_274375782.jpeg",
            "thumb_link": "http://photos1.meetupstatic.com/photos/event/d/9/e/6/thumb_274375782.jpeg",
            "photo_id": 274375782
          },
          "created": 1252978801000,
          "description": "<p>Ottawa Ruby is a group of programming enthusiasts that get together once in a while to hack, present, and talk about the Ruby programming language. Join us on our website and mailing lists at http://www.ottawaruby.ca/</p>",
          "name": "Ottawa Ruby – we <3 programming",
          "rating": 4.46,
          "urlname": "OttawaRuby",
          "lat": 45.43000030517578,
          "members": 439
        },

        {
          "lon": -75.69000244140625,
          "visibility": "public",
          "organizer": {
            "name": "Joe User",
            "member_id": 21
          },
          "link": "http://www.meetup.com/FooJs/",
          "state": "ON",
          "join_mode": "open",
          "who": "Foos",
          "country": "CA",
          "city": "Ottawa",
          "id": 521325,
          "category": {
            "id": 34,
            "name": "tech",
            "shortname": "tech"
          },
          "topics": [
            {
              "id": 563,
              "urlkey": "opensource",
              "name": "Open Source"
            },
            {
              "id": 1040,
              "urlkey": "foojs",
              "name": "FooJs"
            }
          ],
          "timezone": "Canada/Eastern",
          "group_photo": {
            "photo_link": "http://photos1.meetupstatic.com/photos/event/d/9/e/6/600_521325.jpeg",
            "highres_link": "http://photos1.meetupstatic.com/photos/event/d/9/e/6/highres_521325.jpeg",
            "thumb_link": "http://photos1.meetupstatic.com/photos/event/d/9/e/6/thumb_521325.jpeg",
            "photo_id": 521325
          },
          "created": 1252978801000,
          "description": "<p>Group to learn about Foo.js</p>",
          "name": "Ottawa Foo.js",
          "rating": 1.46,
          "urlname": "OttawaFooJs",
          "lat": 45.43000030517578,
          "members": 9
        }
      ],

      "meta": {}
    }'

    ActiveSupport::JSON.decode(json_s)
  end

  def new_github_project_array
    # source: http://developer.github.com/guides/getting-started/ - see Repositories
    #   GET https://api.github.com/users/technoweenie/repos?type=owner
    #   Note: only relevant attributes are kept in the following json payload
    json_s = '[
  {
    "id": 9003920,
    "name": "hash-to-conditions",
    "full_name": "fun-ruby/hash-to-conditions",
    "owner": {
      "login": "fun-ruby",
      "id": 4820953,
      "type": "User"
    },
    "private": false,
    "html_url": "https://github.com/fun-ruby/hash-to-conditions",
    "description": "Transforms a given Hash into an Array condition, for use with ActiveRecord find() or where() methods ",
    "fork": false,
    "created_at": "2013-05-26T04:20:46Z",
    "homepage": "",
    "language": "Ruby"
  },
  {
    "id": 9003929,
    "name": "ProjectNightMeta",
    "full_name": "fun-ruby/ProjectNightMeta",
    "owner": {
      "login": "fun-ruby",
      "id": 4820953,
      "type": "User"
    },
    "private": false,
    "html_url": "https://github.com/fun-ruby/ProjectNightMeta",
    "description": "A Project Night Project for organizing Project Nights",
    "fork": true,
    "created_at": "2013-08-31T17:39:45Z",
    "homepage": null,
    "language": "Ruby"
  }
]'

    ActiveSupport::JSON.decode(json_s)
  end

end
