if RUBY_VERSION > "1.9"
  require 'simplecov'
  require 'simplecov-gem-adapter'
  SimpleCov.start 'gem'
end

require 'rspec'
require 'sndfile'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end

INPUTS_DIR = Pathname.new(__FILE__) + "../inputs"
REFS_DIR = Pathname.new(__FILE__) + "../refs"
OUTPUTS_DIR = Pathname.new(__FILE__) + "../outputs"
Dir.mkdir(OUTPUTS_DIR) unless File.directory? OUTPUTS_DIR

def in_path(name)
  INPUTS_DIR + name
end

def out_ref_paths(name)
  [
    OUTPUTS_DIR + "out-#{name}",
    REFS_DIR + "ref-#{name}",
  ]
end

