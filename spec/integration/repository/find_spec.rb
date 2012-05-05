require 'integration/spec_helper'

describe Entrepot::Repository do
  before(:each) do
    Entrepot.data_store.send(:reset!)
  end

  describe :find do
    let(:id)         { BSON::ObjectId.new }
    let(:address)    { { :street => "Dachstr 15", :city => "Dresden", :country => "Deutschland"     } }
    let(:attributes) { { :_id => id, :name => "John Lennon", :address => address} }
    let(:object)     { Person.new(attributes) }

    let(:repository) { PersonRepository }

    before(:each) do
      repository.insert(object)
    end

    context "by record ID" do
      it "finds the record" do
        repository.find(id).should be_instantiated_from object
      end

      it "finds the record when ID is string" do
        repository.find(id.to_s).should be_instantiated_from object
      end
    end

    context "by query" do
      it "finds the record" do
        repository.find({:name => /^John/}).first.should be_instantiated_from object
      end
    end

    context "when record does not exist" do
      it "raises not found exception" do
        lambda {
          repository.find(BSON::ObjectId.new).to_hash
        }.should raise_exception
      end
    end

    context "when record has embedded records" do
      it "fills in embedded records" do
        repository.find(id).address.is_a?(Address).should be_true
        repository.find(id).address.to_hash.should eql address
      end
    end

    context "when given record is of a type, derived from the repository class" do
      let(:object)     { Manager.new(attributes) }

      it "instantiates correct record type" do
        repository.find(id).is_a?(Manager).should be_true
      end
    end

    context "when entry has referenced associations" do
      describe "when association is loaded eagerly" do
        it "loads the assoc."
      end
      describe "when association is not loaded eagerly" do
        it "fills up an assoc. with an lazy-evaled method"
      end
    end

  end

end
