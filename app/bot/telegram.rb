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
      history = Dialog.new(message.chat.id,HistoryStorage.get_user_session(chat_id))
      if message.location
        if history.state != 'point_location'
          create_points_message(chat_id, message.location.latitude, message.location.longitude)
        end
      else
        case message.text
          when '/start'
            send_reply chat_id, 'Привет, я помогу тебе найти алкоголь ночью. Отправь мне свою локацию.', initial_keyboard
          else
            coords = Geocoder.coordinates(message.text)
            create_points_message(chat_id,coords[0],coords[1])
        end
      end
    rescue => ex
      Rails.logger.error "Telegram bot  error: #{ex.message}"
      send_reply message.chat.id, 'Упс, у меня что-то сломалось. Попробуйте написать что-то другое.'
    end
  end

  def create_points_message(chat_id, lat, lng)
    points = Point.by_distance(lat, lng)
    reply = points_msg(points)
    send_reply chat_id, reply[:text], reply[:keyboard]
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
    text = "#{p.name}\n#{p.description}\n---\n"
    btn = Telegram::Bot::Types::InlineKeyboardButton.new text: "#{p.name} -- #{(p.distance * 1609.34).round(0)}м",
                                                   url: "https://maps.google.com/?q=#{p.lat},#{p.lng}"
    {
        text:text,
        btn: btn
    }
  end

  def points_msg(points)
    buttons = []
    string = "Вот что мне удалось найти: \n"
    points.each do |p|
      spoint = point(p)
      buttons << spoint[:btn]
      string += spoint[:text]
    end
    {
        text: string,
        keyboard: Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: buttons)
    }
  end
end