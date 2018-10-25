module Hue
  class Recipe
    
    BRIGHT = {
      :on => true,
      :saturation => 254,
      :brightness => 254, 
      :color_temperature => 300, 
      :colormode => "ct"
    }
    
    BRIGHT_BLOOM = {
      :on => true,
      :sat => 25,
      :hue => 46920
    }
    
    CONCENTRATE = {
      :on => true,
      :saturation => 254,
      :brightness => 254, 
      :color_temperature => 233, 
      :colormode => "ct"
    }
    
    CONCENTRATE_BLOOM = {
      :on => true,
      :sat => 25,
      :hue => 46920,
      :brightness=>254
    }
    
    READ = {
      :on => true,
      :saturation => nil,
      :brightness => 220, 
      :color_temperature => 343, 
      :colormode => "ct"
    }
    
    READ_BLOOM = {
      :on => true,
      :sat => 25,
      :hue => 46920
    }
    
    DIM = {
      :on => true, 
      :brightness => 62, 
      :color_temperature => 447, 
      :colormode => "ct"
    }
    
    DIM_BLOOM  = {
      :on => true,
      :sat => 25,
      :hue => 46920,
      :brightness => 62
    }
    
    NIGHTLIGHT = {
      :on => true, 
      :brightness => 62, 
      :color_temperature => 447, 
      :colormode => "ct"
    }
    
    NIGHTLIGHT_BLOOM  = {
      :on => true,
      :sat => 25,
      :hue => 46920,
      :brightness => 62
    }
    
  end
end