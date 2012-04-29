require 'integration/spec_helper'

require 'virtus'

describe Entrepot::Repository do
  before(:each) do
    Entrepot.data_store.send(:reset!)
  end

  describe :collection_name do

    context "non-namespaced" do
      class PictureRepository
        include Entrepot::Repository
      end

      it "returns correct collection name" do
        PictureRepository.collection_name.should eql "pictures"
      end
    end

    context "namepaced" do
      module Test
        class PictureRepository
          include Entrepot::Repository
        end
      end

      it "returns correct collection name" do
        Test::PictureRepository.collection_name.should eql "test_pictures"
      end
    end
  end

  describe :klass do
    it "correctly identifies the repository record class" do
      PersonRepository.klass.should eql Person
    end
  end

  describe :insert do
    let(:repository) { PersonRepository }

    context "when given a hash" do
      let(:object) {  {:name => "John Lennon", :address => "Lennonstr 250, Leiningen"}  }

      it "inserts document" do
        repository.insert(object)
        repository.count({ :name => "John Lennon" }).should eql 1
      end

      it "returns a klass record, that evaluates back to same hash" do
        repository.insert(object).to_hash.reject do |k,v| k == :_id end.should eql object
      end

      it "returns a repository model record" do
        repository.insert(object).is_a?(Person).should be_true
      end
    end

    context "when given a repository model" do
      let(:object) { Person.new({:name => "John Lennon", :address => "Lennonstr 250, Leiningen"}) }

      it "inserts document" do
        repository.insert(object)
        repository.count({ :name => "John Lennon" }).should eql 1
      end

      it "marks object as persisted" do
        repository.insert(object)
        object.persisted?.should be_true
      end

      it "sets document id" do
        object.id.should be_nil
        repository.insert(object)
        object.id.should_not be_nil
      end

      it "inserts object to the database" do
        repository.insert(object)
        repository.find(object.id).to_hash.should eql object.to_hash
      end
    end

    context "when given a model of a different repository" do
      it "raises an exception" do
        lambda {
          repository.insert(object)
        }.should raise_exception
      end
    end

    context "when model has embedded records" do
      it "persists embedded records"
    end

    context "when model has referenced records" do
    end
  end

  describe :update do
    let(:repository) { PersonRepository }

    let(:object) { Person.new({:name => "John Lennon", :address => "Lennonstr 250, Leiningen"}) }

    context "when given a hash" do
      context "when the record is unidentifiable (no _id is set)" do
        it "throws an exception" do

        end
      end

      context "when the record is identifiable (_id is set)" do
        it "updates the record"
      end

      context "when the record is identifiable (:query attribute passed)" do
        it "updates the record"
      end

      context "when atomic modifiers are given" do
        it "updates the record in the database"

        it "updates the record" do
          repository.insert(object)
          repository.update(object, :atomic_modifiers => { "$set" => { :address => "Changed address" } })
          object.address.should eql "Changed address"
        end
      end

    end

    context "when given a record" do
      context "when the record is unidentifiable (no id set)" do
        it "throws an exception"
      end


    end
  end

  describe :save_or_update do

  end

  describe :insert_batch do
    it "batch-inserts records"
  end


  describe :find do
    it "finds the record" do

    end

    it "instantiates the correct record type" do

    end

    it "fills in embedded records" do

    end

    describe "when entry has referenced associations" do
      describe "when association is loaded eagerly" do
        it "loads the assoc."
      end
      describe "when association is not loaded eagerly" do
        it "fills up an assoc. with an lazy-evaled method"
      end
    end
  end

  describe :map_reduce do
    it "should run map-reduce query on the collection"
  end

  describe :drop do
    it "should drop the collection"
  end


end

# person = Person.new(:name => "name", :gender => "gender", :articles => [ { :title => "title 1", :text => "text 1" }, { :title => "title 2", :text => "text 2" } ], :address => { :street => "street", :city => "city", :country => "country" } )

# person_repository = PersonRepository.new
# person_repository.insert(person)

# puts person_repository.find_by_id().first

