#!/usr/bin/env ruby

class Arguments
  attr_accessor :file
  attr_accessor :type
  attr_accessor :open_with
  attr_accessor :temp_dir
  attr_accessor :debug_file
  attr_accessor :debug

  def temp_dir
    @temp_dir ||= "/tempfiles/mutt_attachments"
  end

  def debug_file
    @debug_file ||= File.join(temp_dir, "debug")
  end

  def debug
    @debug = true if @debug == nil
    @debug
  end

  def base_file_name
    @base_file_name ||= File.basename(file)
  end

  def base_file_name_without_extension
    File.basename(base_file_name, File.extname(base_file_name))
  end
end

def build_arguments(arguments)
  result = Arguments.new

  arguments.each do|argument|
    pair = argument.split(":")
    name = pair[0].gsub(/-/,"")
    value = pair[1]
    result.send "#{name}=", value
  end
  result
end

class Debug
  def initialize(filename)
    @file_name = filename
  end

  def write(message)
    File.open(@file_name,'a') do |file|
      file << "#{message}\n"
    end
  end
end

arguments = build_arguments(ARGV)
debug = Debug.new(arguments.debug_file)

system("mkdir -p #{arguments.temp_dir}")
system("rm -rf #{arguments.temp_dir}/*")

if arguments.debug
  debug.write "Arguments: #{ARGV.join(" ")}"
  debug.write "Filename:#{arguments.file}"
  debug.write "File Type:#{arguments.type}"
end

new_file_name = ""
if (arguments.type == "-")
  new_file_name = arguments.type 
else
  new_file_name = "#{arguments.base_file_name_without_extension}.#{arguments.type}"
end

new_file_name = File.join(arguments.temp_dir, new_file_name)
File.cp arguments.file, new_file_name

if (arguments.open_with)
  system("open -a #{arguments.open_with} #{new_file_name}")
else
  system("open #{new_file_name}")
end
