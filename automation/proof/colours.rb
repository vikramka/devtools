module Proof
  module Runner
    module Colours
      extend self

      ALL = {
        :black => 0,
        :red => 1,
        :green => 2,
        :yellow => 3,
        :blue => 4,
        :magenta => 5,
        :cyan => 6,
        :white => 7,
        :light_black => 10,
        :light_red => 11,
        :light_green => 12,
        :light_yellow => 13,
        :light_blue => 14,
        :light_magenta => 15,
        :light_cyan => 16,
        :light_white => 17,
        :default => 9
      }

      def self.get_colour_value(colour_name)
        colour_value = ALL[colour_name]
        colour_value += 50 if colour_value > 10
        colour_value + 30
      end

      def self.each_colour(&block)
        ALL.each_key(&block)
      end
    end
  end
end
