require 'turing_question'
data = YAML.load_file(File.join(Rails.root, 'config', 'turing-questions.yml'))
TURING_QUESTIONS = data[Rails.env]
