module Proof
  module Runner
    module LineFormatters
      extend self

      def create_proof_line_formatter(colour)
        Proc.new do|match|
          puts "#{colour.underline.render(match[1])}#{colour.render(match[2])}"
        end
      end

      def create_proof_summary_line_formatter(colour,status)
        Proc.new do|lines_processed|
          "#{colour.underline.render(status)}#{colour.render(lines_processed)}"
        end
      end

      colour = Proof::Runner::ColouredText.build
      PASS_COLOUR = colour.light_green
      FAIL_COLOUR = colour.red
      ERROR_COLOUR = colour.light_red

      PASS_LINE_FORMATTER = create_proof_line_formatter(PASS_COLOUR)
      PASS_SUMMARY_FORMATTER = create_proof_summary_line_formatter(PASS_COLOUR,"Passed:")
      FAIL_LINE_FORMATTER = create_proof_line_formatter(FAIL_COLOUR)
      FAIL_SUMMARY_FORMATTER = create_proof_summary_line_formatter(FAIL_COLOUR,"Failed:")
      ERROR_LINE_FORMATTER = create_proof_line_formatter(ERROR_COLOUR)
      ERROR_SUMMARY_FORMATTER = create_proof_summary_line_formatter(ERROR_COLOUR,"Errors:")

      NORMAL_LINE_FORMATTER = Proc.new {|match| puts match[0]}
      NORMAL_LINE_SUMMARY_FORMATTER = Proc.new{|lines|}

    end
  end
end
