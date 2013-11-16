# most of this was taken from https://github.com/bobbrodie/siriproxy-wemo.

require 'curb'
require 'simple_upnp'
module Wemo
  class Switch
    def self.on(name)
      send_command(name, 'on')
    end

    def self.off(name)
      send_command(name, 'off')
    end

    def self.state(name)
      send_command(name, 'off')
    end

    def self.set_binary_state(device_location, signal)
      c = Curl::Easy.new(device_location.to_s + 'upnp/control/basicevent1')
      c.headers["Content-type"] = 'text/xml; charset="utf-8"'
      c.headers["SOAPACTION"] = "\"urn:Belkin:service:basicevent:1#SetBinaryState\""
      c.verbose = false
      begin
        c.http_post("<?xml version='1.0' encoding='utf-8'?><s:Envelope xmlns:s='http://schemas.xmlsoap.org/soap/envelope/' s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><s:Body><u:SetBinaryState xmlns:u='urn:Belkin:service:basicevent:1'><BinaryState>#{signal}</BinaryState></u:SetBinaryState></s:Body></s:Envelope>")
        c.perform
      rescue Curb::Err
      end
        # c.body_str
    end

    def self.send_command(wemo, action)
      case action
      when "on"
        signal = 1
      when "off"
        signal = 0
      end
      include_location_details = true
      wemo_device = nil
      device_name = nil
      device_location = nil

      SimpleUpnp::Discovery.find do |device|
        begin
          device_json = device.to_json(include_location_details)
        rescue
          next
        end

        # puts device_json.inspect
        
        if device_json['root']
          if device_json['root']['device']
            if device_json['root']['device']['friendlyName']
              friendlyName = device_json['root']['device']['friendlyName']
              if friendlyName.downcase == wemo.strip.downcase
                wemo_device = device_json['root']['device']
                device_name = friendlyName
                device_location = /https?:\/\/[\S]+\//.match(device.location)
                break
              end
            end
          end
        end
      end
      if wemo_device
        set_binary_state(device_location, signal)
      end
    end
  end
end