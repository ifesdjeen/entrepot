RSpec::Matchers.define :be_instantiated_from do
  match do |actual, expected|
    actual.to_hash.reject do |k,v| k == :_id end.should eql object
  end
end
