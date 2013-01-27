module Proof
  module Runner
    class ColouredText
      attr_reader :colour
      attr_reader :effect

      def initialize(colour,effect)
        @colour = colour
        @effect = effect
      end

      Proof::Runner::Colours.each_colour do |name|
        define_method name do
          self.change_settings(:colour => name)
        end
      end

      Proof::Runner::TEXT_EFFECTS.each_key do | key |
        define_method key do
        self.change_settings( :effect => key )
      end
      end

      def self.build (values = nil)
        values ||= {}
        values =  {:colour => :default, :effect => :default }.merge( values )

        new_colour = Proof::Runner::Colours.get_colour_value(values[:colour])
        new_effect = Proof::Runner::TEXT_EFFECTS[values[:effect]]

        new new_colour, new_effect
      end

      def render(text)
         "\e[#{effect};#{colour}m#{text}\e[0m"
      end

      def reset
        self.effect_default
      end

      def change_settings( settings )
        new_colour = settings.fetch(:colour,nil)
        new_colour = new_colour.nil? ? @colour : Proof::Runner::Colours.get_colour_value(new_colour)
        new_effect = settings.fetch(:effect, nil)
        new_effect = new_effect.nil? ? @effect : Proof::Runner::TEXT_EFFECTS[new_effect]

        self.class.new new_colour, new_effect
      end
    end

  end
end
