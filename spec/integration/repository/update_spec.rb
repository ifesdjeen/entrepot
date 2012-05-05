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

    context "when the record is unidentifiable (no id is set)" do
      it "raises an exception" do
        object.id = nil
        lambda {
          repository.update(object)
        }.should raise_exception
      end
    end

    context "when the record is identifiable (id is set)" do
      it "updates the record" do
        object.name = "New Groove"
        repository.update(object)
        object.name.should eql "New Groove"
      end
    end

    context "when the record is identifiable (:query attribute passed)" do
      it "updates the record" do
        object.name = "New Groove"
        repository.update(object, :query => { :name => /^John/ })
        object.name.should eql "New Groove"
      end
    end

    context "when atomic modifiers are given" do
      it "updates the record in the database" do
        repository.update(object, :atomic_modifiers => { "$set" => { :name => "New Groove" } })
        repository.find(object.id).name.should eql "New Groove"
      end

      it "updates the record" do
        repository.update(object, :atomic_modifiers => { "$set" => { :name => "New Groove" } })
        object.name.should eql "New Groove"
      end
    end

  end

end
