class TelegramBot

  Token = ENV['TG_TOKEN']

  def initialize
    Rails.logger.info 'Bot started'
    @client = Telegram::Bot::Client.new(Token)
  end

  def update(data)
    begin
      update = Telegram::Bot::Types::Update.new(data)

      message = update.message

      process message

    rescue Exception => e
      Rails.logger.error e
    end
  end

  private

  def process(msg)
    Rails.logger.debug msg.to_yaml
    case msg
      when Telegram::Bot::Types::InlineQuery
        process_inline msg
      when Telegram::Bot::Types::Message
        process_message msg
      when Telegram::Bot::Types::CallbackQuery
        process_cb msg
    end
  end

  def process_message(message)
    begin
      chat_id = message.chat.id
      if message.location
        points  = Point.where("lat <= #{message.location.latitude+0.02} and lat >= #{message.location.latitude-0.02} and lng <= #{message.location.longitude+0.02} and lng >= #{message.location.longitude-0.02}").limit(5)
        send_reply chat_id, 'Вот что я нашел рядом', points_msg(points)
      else
        send_reply chat_id, 'Привет, я помогу тебе найти алкоголь ночью. Отправь мне свою локацию.', initial_keyboard
      end
    rescue ApiException => ex
      send_reply message.chat.id, ex.message
    rescue => ex
      Rails.logger.error "Telegram bot  error: #{ex.message}"
      send_reply message.chat.id, 'Упс, у меня что-то сломалось. Попробуйте написать что-то другое.'
    end
  end

  def process_cb (msg)

  end

  def send_reply(chat_id, text, keyboard=nil)
    @client.api.send_message chat_id: chat_id,
                             reply_markup: keyboard,
                           text: text
  end


  def send_link id,uname,name,link

  end

  def initial_keyboard
    chat = Telegram::Bot::Types::KeyboardButton.new text: "Найти алкоголь ночью",
                                                    request_location: true
    Telegram::Bot::Types::ReplyKeyboardMarkup.new keyboard:[chat],
                                                  resize_keyboard: true
  end

  def point(p)
    Telegram::Bot::Types::InlineKeyboardButton.new text: "#{p.name} -- #{p.description}",
                                                   url: "https://maps.google.com/?q=#{p.lat},#{p.lng}"
  end

  def points_msg(points)
    serialized = []
    points.each do |p|
      serialized << point(p)
    end
    Telegram::Bot::Types::InlineKeyboardMarkup.new inline_keyboard: serialized
  end
end