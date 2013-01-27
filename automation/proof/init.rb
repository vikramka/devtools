dir = File.dirname(__FILE__)
dir = File.join(dir,"lib")
dir = File.expand_path(dir)

$LOAD_PATH.unshift dir unless $LOAD_PATH.include?(dir)

require_relative 'local_proof'
