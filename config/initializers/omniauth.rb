Rails.application.config.middleware.use OmniAuth::Builder do
  # this is just for test and only allow redirect to localhost:3000
  provider :facebook, APP_CONFIG["facebook"]["app_id"], APP_CONFIG["facebook"]["app_secret"]
end 
