require 'chefspec'
require 'chefspec/berkshelf'

current_dir = File.dirname(File.expand_path(__FILE__))
Dir[File.join(current_dir, 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.platform = 'centos'
  config.version = '7.2'
  config.log_level = :fatal
end
