Rails.application.config.middleware.use Rack::CanonicalHost do
  case ENV['RACK_ENV'].to_sym
    when :production then 'www.studyhall.com'
  end
end