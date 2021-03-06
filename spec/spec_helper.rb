$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'patron' unless RUBY_PLATFORM =~ /java/
require 'httpclient'
require 'em-http' unless RUBY_PLATFORM =~ /java/
require 'vcr'
require 'vcr/http_stubbing_adapters/fakeweb'
require 'vcr/http_stubbing_adapters/webmock'
require 'spec'
require 'spec/autorun'

begin
  require 'ruby-debug'
  Debugger.start
  Debugger.settings[:autoeval] = true if Debugger.respond_to?(:settings)
rescue LoadError
  # ruby-debug wasn't available so neither can the debugging be
end

# Ruby 1.9.1 has a different yaml serialization format.
YAML_SERIALIZATION_VERSION = RUBY_VERSION == '1.9.1' ? '1.9.1' : 'not_1.9.1'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
  config.extend TempCassetteLibraryDir
  config.extend DisableWarnings

  config.before(:each) do
    VCR::Config.default_cassette_options = { :record => :new_episodes }
    VCR::Config.http_stubbing_library = :fakeweb

    WebMock.allow_net_connect!
    WebMock.reset_webmock

    FakeWeb.allow_net_connect = true
    FakeWeb.clean_registry
  end
end
