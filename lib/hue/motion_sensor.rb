module Hue
  class MotionSensor
    include TranslateKeys    
    
    attr_reader :name
    
    attr_reader :hue_device_type
    
    attr_reader :hue_device_name
    
    attr_reader :unique_id
    
    attr_reader :state
    
    attr_reader :presence
    
    attr_reader :updated_at
    
    def initialize(client, bridge, id, hash)
      @client = client
      @bridge = bridge
      @id = id
      unpack(hash)
    end
    
    # Refresh the state of the lamp
    def refresh
      json = JSON(Net::HTTP.get(URI.parse(base_url)))
      unpack(json)
    end

  private

    KEYS_MAP = {
      :name            => :name,
      :hue_device_type => :type,
      :hue_device_name => :productname,
      :unique_id       => :uniqueid,
      :state           => :state
    }

    def unpack(hash)
      unpack_hash(hash, KEYS_MAP)
      @updated_at = @state["updatedat"]
      @presence = @state["presence"]
    end

    def base_url
      "http://#{@bridge.ip}/api/#{@client.username}/sensors/#{id}"
    end
  end
end
