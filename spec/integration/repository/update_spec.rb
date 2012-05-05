require 'integration/spec_helper'

describe Entrepot::Repository do
  before(:each) do
    Entrepot.data_store.send(:reset!)
  end

  describe :update do
    let(:repository) { PersonRepository }

    let(:object) { Person.new({:name => "John Lennon", :address => "Lennonstr 250, Leiningen"}) }

    context "when given a hash" do
      context "when the record is unidentifiable (no _id is set)" do
        it "raises an exception" do

        end
      end

      context "when the record is identifiable (_id is set)" do
        it "updates the record" do
          repository.insert(object)
          object.name = "New Groove"
          repository.update(object)
          object.name.should eql "New Groove"
        end
      end

      context "when the record is identifiable (:query attribute passed)" do
        it "updates the record" do
          repository.insert(object)
          object.name = "New Groove"
          repository.update(object, :query => { :name => /^John/ })
          object.name.should eql "New Groove"
        end
      end

      context "when atomic modifiers are given" do
        it "updates the record in the database"

        it "updates the record" do
          repository.insert(object)
          repository.update(object, :atomic_modifiers => { "$set" => { :name => "New Groove" } })
          object.name.should eql "New Groove"
        end
      end

    end

    context "when given a record" do
      context "when the record is unidentifiable (no id set)" do
        it "raises an exception"
      end


    end
  end

end
