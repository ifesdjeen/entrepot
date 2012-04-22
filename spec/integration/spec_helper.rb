require 'spec_helper'

%w(models repositories).each do |dir|
  dir = File.join(File.dirname(__FILE__), "fixtures/#{dir}")
  Dir[File.join(dir, "*.rb")].sort.each { |f| require(f) }
end
