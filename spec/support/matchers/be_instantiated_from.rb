RSpec::Matchers.define :be_instantiated_from do |expected|
  def reject_id(obj)
    obj.to_hash.reject.reject do |k,v| k == :_id end
  end

  match do |actual|
    reject_id(actual).should eql reject_id(expected)
  end

  failure_message_for_should do |actual|
    msg = "#{actual.to_hash.inspect} \n Was supposed to be instantiated from \n#{expected}\n, but: \n"
    reject_id(actual).each do |k,v|
      msg<< "Key \"#{k}\" with value \"#{v}\" did not match expected \"#{expected[k]}\" \n" unless v == expected[k]
    end
    msg
  end
end
