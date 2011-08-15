class Twiddla
  include HTTParty
  base_uri "http://www.twiddla.com"
  DEFAULT_PARAMS = {:username => "brentmc79", :password => "intridea4me"}

  def self.get_whiteboard
    Rails.logger.info("Posting to Twiddla...")
    response = self.post("/new.aspx",{:body => DEFAULT_PARAMS}).body
    Rails.logger.info("Twiddla responded with: \"#{response}\"")
    raise TwiddlaError.new("Problem retrieving session identifier") if response == "-1"
    response
  end
    
end

class TwiddlaError < StandardError; end
