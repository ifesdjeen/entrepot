class PersonRepository
  include Entrepot::Repository

  def collection_name
    "people"
  end

  has_many :articles, :repository => :ArticleRepository
end
