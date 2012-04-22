# encoding: utf-8

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
ENV["RAILS_ENV"] ||= 'test'

require 'bundler'

require 'entrepot'
Bundler.setup(:default, :test)

support = File.join(File.dirname(__FILE__), "support")
Dir[File.join(support, "support/**/*.rb")].sort.each { |f| require(f) }

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:each) do

  end

  config.after(:suite) do

  end

  config.before(:each) do

  end
end
