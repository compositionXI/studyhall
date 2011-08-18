class Poc::Whiteboard < ActiveRecord::Base
  set_table_name :poc_whiteboards

  before_validation :retrieve_session_identifier

  OPTIONAL_COMPONENTS = %w{chat invite profile voice etherpad documents images bottomtray email widgets math}
  RECOMMENDED_COMPONENTS = %w{etherpad documents images}

  def retrieve_session_identifier
    return true unless session_identifier.blank?
    begin
      self.session_identifier = Twiddla.get_whiteboard
    rescue TwiddlaError => e
      self.errors << "Could not retrieve session identifier"
    end
  end

  def hidden_components
    OPTIONAL_COMPONENTS.reject do |component|
      send("#{component}_component?")
    end
  end

  def included_components
    OPTIONAL_COMPONENTS.select do |component|
      send("#{component}_component?")
    end
  end

  def name
    if included_components.empty?
      "Basic Whiteboard"
    elsif included_components.size == OPTIONAL_COMPONENTS.size
      "Fully-featured Whiteboard"
    else
      included_components.map(&:capitalize).join(", ")
    end
  end

  def url
    base = "http://www.twiddla.com"
    uri = "/api/start.aspx"
    params = []
    params << "sessionid=#{self.session_identifier}"
    params << "hide=#{hidden_components.join(",")}"
    params << "guestname=brent"
    params << "autostart=true"
    params << "css=http://#{APP_CONFIG["host"]}/stylesheets/twiddla.css" if custom_css?
    full_url = base
    full_url << uri
    full_url << "?" if params.any?
    full_url << params.join("&") if params.any?
    full_url
  end
end
