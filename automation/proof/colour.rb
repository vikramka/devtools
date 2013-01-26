require 'ostruct'

module Console
  COLOURS = {
    :black => 0,
    :red => 1,
    :green => 2,
    :yellow => 3,
    :blue => 4,
    :magenta => 5,
    :cyan => 6,
    :white => 7,
    :default => 9,
    
    :light_black => 10,
    :light_red => 11,
    :light_green => 12,
    :light_yellow => 13,
    :light_blue => 14,
    :light_magenta => 15,
    :light_cyan => 16,
    :light_white => 17
  }

  MODES = {
    :default => 0, 
    :underline => 4, 
    :blink => 5, 
    :swap_foreground_and_background_colour => 7, 
    :hide_text => 8 
  }

end
class String

  class ColourSettings < OpenStruct
    def self.build(values)
      default_colour = Console::COLOURS[:default]
      default_mode = Console::MODES[:default]

      colour = default_colour
      background = default_colour
      mode = default_mode

      if (values.instance_of?(Hash))
        colour = COLOURS[values[:colour]]
        background = COLOURS[values[:background]]
        mode = MODES[values[:mode]]
      elsif (values.instance_of?(Symbol))
        colour = COLOURS[values]
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
  
  COLOURS.each_key do | key |
    next if key == :default

    define_method key do
      self.colourize( :colour => key )
    end
    
    define_method "on_#{key}" do
      self.colourize( :background => key )
    end
  end

  MODES.each_key do | key |
    next if key == :default
    
    define_method key do
      self.colourize( :mode => key )
    end
  end
end
