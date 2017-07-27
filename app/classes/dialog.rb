class Dialog

  STATES = %w(start new finish address cancel point_name point_description point_location point_type point_options)

  attr_reader :id
  attr_accessor :state
  attr_reader :answers

  def initialize chat_id, json
    @id = chat_id
    @state = json.nil? ? STATES[0] : json.state
    @answers = json.nil? ? {} : json.answers
  end

  def add_answer state, answer
    @answers[state.to_sym] = answer
  end

  def clear
    @state = 'address'
    @answers = {}
  end

  def next_state
    @state = STATES[STATES.index(@state)+1]
  end

  def to_json
    {
        id: @id,
        state: @state,
        answers: @answers
    }.to_json
  end
end