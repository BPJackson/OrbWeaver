Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], scope: 'user-read-email user-follow-read user-follow-modify playlist-modify-public'
end
