Rails.application.config.middleware.use OmniAuth::Builder do
  # this is just for test and only allow redirect to localhost:3000
  provider :facebook, '239998316048833', '3c191804c8169e53b0e182210010dcf7'
end 
