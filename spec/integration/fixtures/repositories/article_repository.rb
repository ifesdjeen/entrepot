class ArticleRepository
  include Entrepot::Repository

  def collection_name
    "articles"
  end

  belongs_to :person, :repository => :PersonRepository
end
