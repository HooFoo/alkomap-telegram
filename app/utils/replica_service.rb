class ReplicaService

  def self.get_replica_for_state(state, message, location={lat: 0, lng: 0})
    self.send state, message
  end

  private

  def self.start(message)
    "Привет, я помогу тебе найти алкоголь ночью. Отправь мне свою локацию или напиши ближайший адрес.\n" +
    "Так же ты можешь рассказать нам о месте, где можно купить алкоголь ночью. /new"
  end

  def self.new(message)
    "Замечательно! Помни, что мне будет нужна его локация, так что это возможно только с телефона. \n\nСначала напиши название точки:"
  end

  def self.point_name(message)
    'Теперь напиши что-то, что его описывает. Если есть особенности покупки, то напиши и их'
  end

  def self.point_description(message)
    "Теперь отправь мне локацию того места, где оно находится. \n\nОтправляй только локацией, адрес строкой не принимается!"
  end

  def self.point_location(message)
    'Хорошо, что это за место?'
  end

  def self.point_type(message)
    'Что в нем есть?'
  end

  def self.point_options(message)
    'Отлично! После проверки она окажется в списке.'
  end

  def self.finish(message)
    'Спасибо! Точка будет доступна при поиске после ее проверки модератором.'
  end

  def self.cancel(message)
    'Ты сможешь добавить точку находясь в ней, это будет гораздо удобнее. Просто как найдешь - пиши!'
  end

  def self.address(message)

  end

  def self.point_option_localization(option)
    case option
      when :isFulltime
        'Открыто круглосуточно'
      when :cardAccepted
        'Принимают к оплате карты'
      when :beer
        'Можно купить пиво'
      when :hard
        'Можно купить крепкий алкоголь'
      when :elite
        'Есть дорогие сорта алкоголя'
    end
  end
end