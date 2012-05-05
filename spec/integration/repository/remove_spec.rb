require 'integration/spec_helper'

describe Entrepot::Repository do
  before(:each) do
    Entrepot.data_store.send(:reset!)
  end

  describe :update do
    let(:repository) { PersonRepository }

    let(:object) { Person.new({:name => "John Lennon", :address => "Lennonstr 250, Leiningen"}) }

    before(:each) do
      repository.insert(object)
    end

    context "when given record" do
      it "removes record from the database" do
        repository.remove(object)
        repository.count({:name => "John Lennon"}).should eql 0
      end
    end

    context "when given an object id" do
      it "removes record from the database" do
        repository.remove(object.id)
        repository.count({:name => "John Lennon"}).should eql 0
      end
    end

    context "when given a string id" do
      it "removes record from the database" do
        repository.remove(object.id.to_s)
        repository.count({:name => "John Lennon"}).should eql 0
      end
    end

    context "when given a query" do
      it "removes record from the database" do
        repository.remove({:name => "John Lennon"})
        repository.count({:name => "John Lennon"}).should eql 0
      end
    end

  end

end
