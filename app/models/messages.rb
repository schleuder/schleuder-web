class Messages
  include Squire::Base

  def self.messages_file
    File.join(Rails.root, 'config', 'messages.yml')
  end

  squire.source self.messages_file
  squire.namespace 'Schleuder'
end
