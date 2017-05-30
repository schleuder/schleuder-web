class TuringQuestion
  attr_reader :id, :question

  def initialize(attributes={})
    attributes.each do |name, value|
      instance_variable_set("@#{name}", value)
    end
  end

  def self.available?
    data.size > 0
  end

  def self.random
    find(random_id)
  end

  def self.find(id)
    id = id.to_i
    question, valid_answers = load_set(id)
    return nil if question.nil?
    self.new(id: id, question: question, valid_answers: valid_answers)
  end

  def valid_answer?(answer)
    @valid_answers.include?(answer.downcase)
  end

  private

  def self.random_id
    rand(data.size)
  end

  def self.load_set(id)
    return nil if data[id].blank?
    question, answers = data[id].values
    answers.map! { |a| a.to_s }
    [question, answers]
  end

  def self.data
    TURING_QUESTIONS[I18n.locale.to_s]
  end

end
