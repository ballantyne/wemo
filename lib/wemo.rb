require 'wemo/version'
require 'wemo/switch'

module Wemo
  NAMESPACE = 'http://www.belkin.com/'

  def self.on(name)
    Wemo::Switch.send_command(name, 'on')
  end

  def self.off(name)
    Wemo::Switch.send_command(name, 'off')
  end
end