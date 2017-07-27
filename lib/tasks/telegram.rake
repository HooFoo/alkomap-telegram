namespace :telegram do
  desc 'Set webhook to ngrok address'
  task :webhook, [:url] => [:environment]do |t, args|
    puts Telegram::Bot::Client.new(ENV['TG_TOKEN']).api.setWebhook(url: "#{ENV['url']}/telegram/webhook")
  end

end
