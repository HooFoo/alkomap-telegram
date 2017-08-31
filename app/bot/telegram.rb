class TelegramBot

  Token = ENV['TG_TOKEN']

  def initialize
    Rails.logger.info 'Bot started'
    @client = Telegram::Bot::Client.new(Token)
  end

  def update(data)
    begin
      update = Telegram::Bot::Types::Update.new(data)

      process update

    rescue Exception => e
      Rails.logger.error e
    end
  end

  private

  def process(msg)
    Rails.logger.debug msg.to_yaml
    case msg.message
      when Telegram::Bot::Types::InlineQuery
      when Telegram::Bot::Types::Message
        process_message msg.message
      when Telegram::Bot::Types::CallbackQuery
        process_callback msg
    end
  end

  def process_message(message)
    begin
      chat_id = message.chat.id
      history = Dialog.new(message.chat.id,HistoryStorage.get_user_session(chat_id))
      if message.location
        if history.state != 'point_description'
          create_points_message(chat_id, message.location.latitude, message.location.longitude)
        else
          history.state = 'point_location'
          send_reply chat_id,
                     ReplicaService.get_replica_for_state(history.state, message), initial_keyboard
        end
      else
        case message.text
          when '/start'
            history.state = 'start'
            send_reply chat_id,
                       ReplicaService.get_replica_for_state(history.state, message.from.first_name), initial_keyboard
          when '/new'
            history.state = 'new'
            send_reply chat_id,
                       ReplicaService.get_replica_for_state(history.state, message.from.first_name), cancel_keyboard
          when '/cancel'
            history.state = 'cancel'
            send_reply chat_id,
                       ReplicaService.get_replica_for_state(history.state, message.from.first_name), initial_keyboard
          else
            if history.state =~ /point_.+/ || history.state == 'new'
              case history.state
                when 'new'
                  history.state = 'point_name'
                  send_reply chat_id,
                             ReplicaService.get_replica_for_state(history.state, message.from.first_name), cancel_keyboard
                when 'point_name'
                  history.state = 'point_description'
                  send_reply chat_id,
                             ReplicaService.get_replica_for_state(history.state, message.from.first_name), location_keyboard
                when 'point_description'
                  history.state = 'point_location'
                  send_reply chat_id,
                             ReplicaService.get_replica_for_state(history.state, message.from.first_name), types_keyboard

                when 'point_type'
                    history.state = 'point_options'
                    send_reply chat_id,
                               ReplicaService.get_replica_for_state(history.state, message.from.first_name), options_keyboard
                when 'point_location'
                    history.state = 'point_type'
                    send_reply chat_id,
                               ReplicaService.get_replica_for_state(history.state, message.from.first_name), cancel_keyboard
                when 'point_options'
                  history.state = 'finish'
                  send_reply chat_id,
                             ReplicaService.get_replica_for_state(history.state, message.from.first_name), cancel_keyboard

              end
            else
              history.state = 'address'
              coords = Geocoder.coordinates(message.text)
              create_points_message(chat_id,coords[0],coords[1])
            end
        end
      end
      answer = {
          text: message.text
      }
      if message.location
        answer[:location] ={
            lat: message.location[:lat],
            lng: message.location[:lng]
        }
      end
      history.add_answer(history.state, answer)
      HistoryStorage.update_user_session chat_id, history
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


  def send_reply(chat_id, text, keyboard=nil)
    @client.api.send_message chat_id: chat_id,
                             reply_markup: keyboard,
                           text: text
  end

  def initial_keyboard
    chat = Telegram::Bot::Types::KeyboardButton.new text: "Найти алкоголь ночью",
                                                    request_location: true
    Telegram::Bot::Types::ReplyKeyboardMarkup.new keyboard:[chat],
                                                  resize_keyboard: true
  end

  def location_keyboard
    chat = Telegram::Bot::Types::KeyboardButton.new text: "Я нахожусь прямо в нем!",
                                                    request_location: true
    cancel = Telegram::Bot::Types::KeyboardButton.new text: "/cancel"
    Telegram::Bot::Types::ReplyKeyboardMarkup.new keyboard:[[chat],[cancel]],
                                                  resize_keyboard: true
  end

  def cancel_keyboard
    chat = Telegram::Bot::Types::KeyboardButton.new text: "/cancel"
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

  def options_keyboard
    buttons = []
   Point::DefaultOptions.each_key do |option|
      id = "option##{SecureRandom.hex(8)}##{option}"
      checked = Point::DefaultOptions[option]
      text = ReplicaService.point_option_localization(option)
      text += ' ✅' if checked
      buttons << Telegram::Bot::Types::InlineKeyboardButton.new( text: text, callback_data: id)
    end
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: buttons)
  end

  def types_keyboard
   buttons = []
   %w(shop bar).each do |option|
      id = "type##{SecureRandom.hex(6)}##{option}"
      text = option == 'shop' ? 'Магазин' : 'Бар'
      buttons << Telegram::Bot::Types::InlineKeyboardButton.new( text: text, callback_data: id)
    end
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: buttons)
  end

  def process_callback(message)
    puts message.data
  end
end