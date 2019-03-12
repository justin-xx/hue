module Hue
  class LightBloom < Light
    def set_to_bright
      set_state({
        :on => true,
        :sat => 25,
        :hue => 46920
      })
    end
    
    def set_to_concentrate
      set_state({
        :on => true,
        :sat => 25,
        :hue => 46920,
        :brightness=>254
      })
    end
    
    def set_to_dim
      set_state({
        :on => true,
        :sat => 25,
        :hue => 46920,
        :brightness => 62
      })
    end
    
    def set_to_read
      set_state({
        :on => true,
        :sat => 25,
        :hue => 46920
      })
    end
    
    def set_to_nightlight
      set_to_off
    end
    
  end
end