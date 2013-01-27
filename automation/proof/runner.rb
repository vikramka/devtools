module Proof
  module Runner
    class Runner
      attr_reader :line_processors
      attr_reader :command

      def initialize(command,line_processors)
        @command = command
        @line_processors = line_processors
      end

      def self.build(command)
        line_formatters = Proof::Runner::LineFormatters
        line_processor = Proof::Runner::LineProcessor
        matchers = Proof::Runner::Matchers

        pass_line_processor = line_processor.new(matchers::PASS, line_formatters::PASS_LINE_FORMATTER, line_formatters::PASS_SUMMARY_FORMATTER)

        fail_line_processor = line_processor.new(matchers::FAIL, line_formatters::FAIL_LINE_FORMATTER, line_formatters::FAIL_SUMMARY_FORMATTER)

        error_line_processor = line_processor.new(matchers::ERROR, line_formatters::ERROR_LINE_FORMATTER, line_formatters::ERROR_SUMMARY_FORMATTER)

        normal_line_processor = line_processor.new(matchers::REGULAR, line_formatters::NORMAL_LINE_FORMATTER, line_formatters::NORMAL_LINE_SUMMARY_FORMATTER)

        line_processors = [
          pass_line_processor,
          fail_line_processor,
          error_line_processor,
          normal_line_processor
        ]

        new command, line_processors
      end

      def highlight_issues_in(raw_output_lines)
        raw_output_lines.each do|line|
          line_processors.each do|processor|
            processor.process line
          end
        end
      end

      def display_summaries
        line_processors.each {|processor| puts processor.summary}
      end

      def run
        display_banner("PROOF RUN STARTED".center(70,'-'),"PROOF RUN ENDED".center(70,'-'), ColouredText.build.light_yellow) do

          raw_output = `#{command}`
          raw_output = raw_output.chomp.split("\n")
          highlight_issues_in(raw_output)
          puts "\n"
          display_summaries
        end

      end

      def display_banner(header,footer, colour = ColouredText.build)
        puts colour.render header
        yield
        puts colour.render footer
      end
    end


    def get_file_to_run
      file_to_run = ARGV[0]
      lib = File.basename(Dir.pwd)
      file_to_run = file_to_run || lib 
    end

    def run(file = nil)
      file ||= get_file_to_run 
      command = "ruby proofs/#{file}.rb"
      Runner.build(command).run
    end
  end
end
