module Hue
  class Bridge
    # ID of the bridge.
    attr_reader :id

    # Name of the bridge. This is also its uPnP name, so will reflect the
    # actual uPnP name after any conflicts have been resolved.
    attr_accessor :name

    # IP address of the bridge.
    attr_reader :ip

    # MAC address of the bridge.
    attr_reader :mac_address

    # IP Address of the proxy server being used.
    attr_reader :proxy_address

    # Port of the proxy being used by the bridge. If set to 0 then a proxy is
    # not being used.
    attr_reader :proxy_port

    # Software version of the bridge.
    attr_reader :software_version

    # Contains information related to software updates.
    attr_reader :software_update

    # An array of whitelisted user IDs.
    attr_reader :ip_whitelist

    # Network mask of the bridge.
    attr_reader :network_mask

    # Gateway IP address of the bridge.
    attr_reader :gateway

    # Whether the IP address of the bridge is obtained with DHCP.
    attr_reader :dhcp

    def initialize(client, hash)
      @client = client
      unpack(hash)
    end

    # Current time stored on the bridge.
    def utc
      json = get_configuration
      DateTime.parse(json['utc'])
    end

    # Indicates whether the link button has been pressed within the last 30
    # seconds.
    def link_button_pressed?
      json = get_configuration
      json['linkbutton']
    end

    # This indicates whether the bridge is registered to synchronize data with a
    # portal account.
    def has_portal_services?
      json = get_configuration
      json['portalservices']
    end

    def refresh
      json = get_configuration
      unpack(json)
      @lights = nil
      @groups = nil
      @scenes = nil
    end

    def lights
      @lights ||= begin
        time1 = Time.now.utc
        json = JSON(Net::HTTP.get(URI.parse(base_url)))
        puts "Downloading took #{Time.now.utc-time1} seconds"
        json['lights'].map do |key, value|
          case value['type']
          when 'Dimmable light' # white only
            LightDimmable.new(@client, self, key, value) 
          when 'Color temperature light' # white ambiance
            LightWhiteAmbiance.new(@client, self, key, value)
          when 'Color light' # bloom
            LightBloom.new(@client, self, key, value)
          when 'Extended color light' # full color
            LightExtendedColor.new(@client, self, key, value)
          else  
            Light.new(@client, self, key, value)
          end
        end
      end
    end

    def add_lights
      uri = URI.parse("#{base_url}/lights")
      http = Net::HTTP.new(uri.host)
      response = http.request_post(uri.path, nil)
      (response.body).first
    end

    def groups
      @groups ||= begin
        json = JSON(Net::HTTP.get(URI.parse("#{base_url}/groups")))
        json.map do |id, data|
          Group.new(@client, self, id, data)
        end
      end
    end

    def scenes
      @scenes ||= begin
        json = JSON(Net::HTTP.get(URI.parse("#{base_url}/scenes")))
        json.map do |id, data|
          Scene.new(@client, self, id, data)
        end
      end
    end
    
    def motion_sensors
      begin
        json = JSON(Net::HTTP.get(URI.parse("#{base_url}/sensors")))
    
        json.map { |id, data|
          if data["state"]["presence"] != nil
            MotionSensor.new(@client, self, id, data)     
          else
            nil
          end          
          
        }.compact # reject the nil's (i.e. sensors that are not motion detectors)
      end
    end

  private

    KEYS_MAP = {
      :id => :id,
      :ip => :internalipaddress,
      :name => :name,
      :proxy_port => :proxyport,
      :software_update => :swupdate,
      :ip_whitelist => :whitelist,
      :software_version => :swversion,
      :proxy_address => :proxyaddress,
      :mac_address => :macaddress,
      :network_mask => :netmask,
      :portal_services => :portalservices,
    }

    def unpack(hash)
      KEYS_MAP.each do |local_key, remote_key|
        value = hash[remote_key.to_s]
        next unless value
        instance_variable_set("@#{local_key}", value)
      end
    end

    def get_configuration
      JSON(Net::HTTP.get(URI.parse("#{base_url}/config")))
    end

    def base_url
      "http://#{ip}/api/#{@client.username}"
    end
  end
end
