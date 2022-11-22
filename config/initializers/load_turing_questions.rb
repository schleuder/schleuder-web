require 'turing_question'
require 'safe_yaml_loader'

data = SafeYamlLoader.load_file(File.join(Rails.root, 'config', 'turing-questions.yml'))
TURING_QUESTIONS = data[Rails.env]
