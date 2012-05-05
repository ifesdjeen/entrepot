require 'integration/spec_helper'

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

  describe :record_class do
    it "correctly identifies the repository record class" do
      PersonRepository.record_class.should eql Person
    end
  end


  describe :save_or_update do

  end

  describe :insert_batch do
    it "batch-inserts records"
  end


  describe :map_reduce do
    it "should run map-reduce query on the collection"
  end

  describe :drop do
    it "should drop the collection"
  end

end
