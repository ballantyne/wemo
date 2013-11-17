# most of this was taken from https://github.com/bobbrodie/siriproxy-wemo.

require 'curb'
require 'simple_upnp'
require 'nokogiri'
module Wemo
  class Switch

    attr_accessor :name, :state, :location, :details

    def initialize(name)
      self.name = name
      self.find_device
      self
    end

    def self.on(name)
      new(name).on
    end

    def self.off(name)
      new(name).off
    end

    def self.status(name)
      new(name).status
    end

    def on
      set_binary_state(1)
    end

    def off
      set_binary_state(0)
    end

    def status
      get_binary_state
    end

    def set_binary_state(signal)
      find_device unless self.location != nil
      c = Curl::Easy.new(self.location.to_s + 'upnp/control/basicevent1')
      c.headers["Content-type"] = 'text/xml; charset="utf-8"'
      c.headers["SOAPACTION"] = "\"urn:Belkin:service:basicevent:1#SetBinaryState\""
      c.verbose = false
      begin
        c.http_post("<?xml version='1.0' encoding='utf-8'?><s:Envelope xmlns:s='http://schemas.xmlsoap.org/soap/envelope/' s:encodingStyle='http://schemas.xmlsoap.org/soap/encoding/'><s:Body><u:SetBinaryState xmlns:u='urn:Belkin:service:basicevent:1'><BinaryState>#{signal}</BinaryState></u:SetBinaryState></s:Body></s:Envelope>")
        c.perform
      rescue 
      end
      self.state = signal
        # c.body_str
    end


    def get_binary_state
      find_device unless self.location != nil
      c = Curl::Easy.new(self.location.to_s + 'upnp/control/basicevent1')
      c.headers["Content-type"] = 'text/xml; charset="utf-8"'
      c.headers["SOAPACTION"] = "\"urn:Belkin:service:basicevent:1#GetBinaryState\""
      c.verbose = false
      begin
        c.http_post("<?xml version=\"1.0\" encoding=\"utf-8\"?><s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><s:Body><u:GetBinaryState xmlns:u=\"urn:Belkin:service:basicevent:1\"></u:GetBinaryState></s:Body></s:Envelope>")
        c.perform
      rescue 
      end
        
      xml =  Nokogiri::XML(c.body_str).text.strip.to_i
      self.state = xml
      if xml == 0
        return false
      else
        return true
      end
    end

    def find_device
      SimpleUpnp::Discovery.find do |device|
        begin
          device_json = device.to_json(true)
        rescue
          next
        end
        # puts device_json.inspect

        if device_json['root']
          if device_json['root']['device']
            if device_json['root']['device']['friendlyName']
              friendlyName = device_json['root']['device']['friendlyName']
              if friendlyName.downcase == self.name.strip.downcase
                self.details = device_json['root']['device']
                self.name = friendlyName
                self.location = /https?:\/\/[\S]+\//.match(device_json[:location]).to_s
                break
              end
            end
          end
        end
      end
      status
    end

    def self.send_command(name, action)
      case action
      when "on"
        signal = 1
      when "off"
        signal = 0
      when 'status'
        signal = false
      end
      d = Wemo::Switch.new(name)
      if d.details
        if signal
          response = d.set_binary_state(signal)
        else
          response = d.get_binary_state
        end
      end
    end
  end
end