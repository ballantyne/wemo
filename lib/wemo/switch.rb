require 'savon'

module Wemo
  class Switch
    PORT = 49153
    ENDPOINT = '/upnp/control/basicevent1'
    XMLNS = 'urn:Belkin:service:basicevent:1'

    attr_accessor :ip

    def initialize(ip)
      @ip = ip
    end

    def on
      send_message('GetBinaryState')
    end

    def on=(state)
      send_message('SetBinaryState', state.to_i)
    end

  # private

    def soap_client
      @soap_client ||= Savon.client endpoint: "http://#{ip}:#{PORT}#{ENDPOINT}", namespace: NAMESPACE
    end

    def send_message(name, value)
      action = "#{XMLNS}##{name}"
      attribute = name.sub('Set', '')
      message = %Q{<u:#{name} xmlns:u="#{XMLNS}"><Desired#{attribute}>#{value}</Desired#{attribute}>}
      soap_client.call(name, soap_action: action, message: message)
    end
  end
end