require 'integration/spec_helper'

describe Entrepot::Repository do
  before(:each) do
    Entrepot.data_store.send(:reset!)
  end

  describe :insert do
    let(:repository) { PersonRepository }
    let(:klass)      { Person }

    let(:address)    { { :street => "Dachstr 15", :city => "Dresden", :country => "Deutschland"     } }
    let(:attributes) { { :name => "John Lennon", :address => address} }
    let(:object)     { Person.new(attributes) }

    context "when given a hash" do

      it "inserts document" do
        repository.insert(object)
        repository.count({ :name => "John Lennon" }).should eql 1
      end

      it "returns a klass record, that evaluates back to same hash" do
        repository.insert(object).should be_instantiated_from attributes
      end

      it "returns a repository model record" do
        repository.insert(object).is_a?(klass).should be_true
      end
    end

    context "when given a repository model" do
      it "inserts document" do
        repository.insert(object)
        repository.count({ :name => "John Lennon" }).should eql 1
      end

      it "marks object as persisted" do
        repository.insert(object)
        object.should be_persisted
      end

      it "sets document id" do
        object.id.should be_nil
        repository.insert(object).inspect
        object.id.should be_instance_of BSON::ObjectId
      end

      it "inserts object to the database" do
        repository.insert(object)
        repository.find(object.id).should be_instantiated_from attributes
      end
    end

    context "when given a model of a different repository" do
      let(:object) { Article.new(:title => "Title") }

      it "raises an exception" do
        lambda {
          repository.insert(object)
        }.should raise_exception
      end
    end

    context "when model has embedded records" do
      it "persists embedded records" do
        repository.insert(object)
        repository.find(object.id).address.should be_instance_of Address
      end
    end

    context "when model has referenced records" do
      it "persist referenced records"
    end
  end

end
