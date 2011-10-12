OPENTOK = OpenTok::OpenTokSDK.new(APP_CONFIG["opentok"]["key"], APP_CONFIG["opentok"]["secret"])
if Rails.env.development? || Rails.env.test?
  OPENTOK.api_url = "https://staging.tokbox.com/hl"
else
  OPENTOK.api_url = "https://api.opentok.com/hl"
end
