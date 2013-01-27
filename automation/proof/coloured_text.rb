module Proof
  module Runner
    class ColouredText
      attr_reader :colour
      attr_reader :effect

      def initialize(colour,effect)
        @colour = colour
        @effect = effect
      end

      Proof::Runner::Colours.each_colour do |colour|
        define_method colour do
          self.change(:colour => colour)
        end
      end

      Proof::Runner::TEXT_EFFECTS.each_key do | effect |
        define_method effect do
          self.change(:effect => effect )
        end
      end

      def self.build
        colour = Proof::Runner::Colours.get_colour_value(:default)
        effect = Proof::Runner::TEXT_EFFECTS[:default]

        new colour, effect
      end

      def render(text)
         "\e[#{effect};#{colour}m#{text}\e[0m"
      end

      def reset
        self.class.build
      end

      def change( settings )
        new_colour = settings.fetch(:colour,nil)
        new_colour = new_colour.nil? ? @colour : Proof::Runner::Colours.get_colour_value(new_colour)

        new_effect = settings.fetch(:effect, nil)
        new_effect = new_effect.nil? ? @effect : Proof::Runner::TEXT_EFFECTS[new_effect]

        self.class.new new_colour, new_effect
      end
    end

  end
end
