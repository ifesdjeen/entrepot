require 'integration/spec_helper'

describe Entrepot::Repository do
  before(:each) do
    Entrepot.data_store.send(:reset!)
  end

  describe :has_many do
    let(:person_repository)  { PersonRepository  }
    let(:article_repository) { ArticleRepository }

    let(:article_attributes) { {:title => "Did he even write articles?", :text => "Imagine there's no heaven, It's easy if you try"} }
    let(:person_attributes)  { {:name => "John Lennon", :articles => article_attributes} }

    let(:person) { Person.new(person_attributes) }

    describe :insert do
      it "persists the referenced record" do
        person_repository.insert(person)

      end
    end

    describe "attributes setup" do
      module HasManySpec
        class Song
          include Entrepot::Mongo::Model

          attribute :title, String
        end

        class Performer
          include Entrepot::Mongo::Model

          attribute :name, String
        end

        class SongRepository
          include ::Entrepot::Repository

          belongs_to :performer, :repository => PerformerRepository
        end

        class PerformerRepository
          include ::Entrepot::Repository

          has_many :songs, :repository => SongsRepository
        end
      end
      Entrepot.finalize!

      it "sets reference and id accessors on the record" do
        song = HasManySpec::Song.new(:title => "Imagine", :performer => {:name => "John Lennon"})
        song.should respond_to :performer
        song.performer.is_a?(HasManySpec::Performer).should be_true
        song.should respond_to :performer_id
      end
    end
  end
end
