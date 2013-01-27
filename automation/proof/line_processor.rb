module Proof
  module Runner
    class LineProcessor
      attr_reader :matcher
      attr_reader :line_match_processing_block
      attr_reader :summary_block
      attr_reader :lines_processed

      def initialize(matcher, line_match_processing_block, summary_block)
        @matcher = matcher
        @line_match_processing_block = line_match_processing_block
        @summary_block = summary_block
        @lines_processed = 0
      end

      def process(line)
        match = matcher.match(line)
        if (match)
          @lines_processed += 1
          line_match_processing_block.call match
        end
      end

      def summary
        summary_block.call lines_processed
      end
    end
  end
end
