class ReplicaService

  def self.get_replica_for_state(state, message, location={lat: 0, lng: 0})
    self.send state, message
  end

  private

  def self.start(message)
    'Привет, я помогу тебе найти алкоголь ночью. Отправь мне свою локацию или напиши ближайший адрес.'
  end

  def self.new(message)
    'Замечательно! Помни, что мне будет нужна его локация, так что это возможно только с телефона.'
  end

  def self.point_name(message, location)
    'Сначала напиши название этого места.'
  end

  def self.point_description(message, location)
    'Теперь напиши что-то, что его описывает'
  end

  def self.point_location(message, location)
    'Теперь пришли мне локацию, где оно находится.'
  end

  def self.point_type(message, location)
    'Выбери тип заведения'
  end

  def self.point_options(message, location)
    'Теперь отметь его свойства'
  end

  def self.finish(message, location)
    'Спасибо! Точка будет доступна при поиске после ее проверки модератором.'
  end

  def self.address(message, location)

  end

end