class ArticleRepository
  include Entrepot::Repository

  belongs_to :person, :repository => :PersonRepository
end
