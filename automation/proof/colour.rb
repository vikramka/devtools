require 'ostruct'

module Console
  STANDARD_COLOURS = {
    :black => 0,
    :red => 1,
    :green => 2,
    :yellow => 3,
    :blue => 4,
    :magenta => 5,
    :cyan => 6,
    :white => 7,
    :default => 9
  }

  class Colours
    Console::STANDARD_COLOURS.each do|name,value|
      light_colour_name = "light_#{name}"
      @colour_names << name
      @colour_names << light_colour_name

      Colours.define_singleton_method name { value }
      Colours.define_singleton_method light_colour_name { value + 10 } 
    end

    def self.colour_names
      @colour_names ||= []
    end

    def self.get_colour_value(name)
      send name
    end

    def self.each_colour(&block)
      @colour_names.each &block
    end
  end

  MODES = {
    :default => 0, 
    :underline => 4, 
    :blink => 5, 
    :swap_foreground_and_background_colour => 7, 
    :hide_text => 8 
  }

end
class String
  COLOUR_MAP = Console::Colours

  class ColourSettings < OpenStruct
    def self.build(values)
      default_colour = COLOUR_MAP.default
      default_mode = Console::MODES[:default]

      colour = default_colour
      background = default_colour
      mode = default_mode

      if (values.instance_of?(Hash))
        colour = COLOUR_MAP.get_colour_value(values[:colour])
        background = COLOUR_MAP.get_colour_value(values[:background])
        mode = MODES[values[:mode]]
      elsif (values.instance_of?(Symbol))
        colour = COLOUR_MAP.get_colour_value(values)
      end

      new :colour => colour, :background => background, :mode => mode
    end
    def calculate_foreground_colour
      colour = self.colour += 50 if self.colour > 10
      colour + 30
    end
    def calculate_background_colour
      colour = self.colour += 50 if self.colour > 10
      colour + 40
    end
  end
  
  
  #
  # Set colour values in new string intance
  #
  def set_colour_settings( settings )
    @colour = settings.colour
    @background = settings.background
    @mode = settings.mode
    @uncolourized = settings.uncolourized
    self
  end


  def colourize( settings )
    return self unless STDOUT.isatty
    
    colour_settings = ColourSettings.build(settings)
    colour_settings.uncolourized ||= @uncolourized ||= self.dup

    colour = colour_settings.calculate_foreground_colour
    background = colour_settings.calculate_background_colour
    mode =  colour_settings.mode
    uncolour =  colour_settings.uncolourized

     "\033[#{mode};#{colour};#{background}m#{uncolour}\033[0m".set_colour_settings( colour_settings )
  end

  def uncolourize
    @uncolourized || self
  end
  
  COLOUR_MAP.each_colour do |name|
    define_method name do
      self.colourize(:colour => name)
    end
    define_method "with_#{name}_background" do
      self.colourize(:background => name)
    end
  end

  MODES.each_key do | key |
    define_method key do
      self.colourize( :mode => key )
    end
  end
end
