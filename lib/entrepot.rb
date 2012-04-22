require 'virtus'

require 'entrepot/repository'
require 'entrepot/model'

module Entrepot

  # DataStore singleton
  def self.data_store
    return @data_store if @data_store
    @data_store = DataStore.new
  end
end
