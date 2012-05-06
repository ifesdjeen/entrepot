class PersonRepository
  include Entrepot::Repository

  has_many :articles, :repository => ArticleRepository
end
