# subscribe to push notification: https://pushed.co/s/IXmzxBa
require_relative '../env'

def push_notification(message)
  url = URI "https://api.pushed.co/1/push"
  req = Net::HTTP::Post.new url.path
  req.set_form_data(
    app_key: PUSHED_APP_KEY,
    app_secret: PUSHED_APP_SECRET,
    target_type: "app",
    content: message
  )
  res = Net::HTTP.new url.host, url.port
  res.use_ssl = true
  res.verify_mode = OpenSSL::SSL::VERIFY_PEER
  res = res.start { |http| http.request req }
  raise "Request failed ... aborting" unless res.class == Net::HTTPOK
  true
end

# push_notification "test"
