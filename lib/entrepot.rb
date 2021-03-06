require 'virtus'

require 'entrepot/data_store'
require 'entrepot/repository'
require 'entrepot/model'

require 'mongo'
require 'entrepot/mongo/data_store'
require 'entrepot/mongo/model'

module Entrepot

  # DataStore singleton
  def self.data_store
    return @data_store if @data_store
    @data_store = Mongo::DataStore.new
  end

  def self.finalize!
    Thread.current['__entrepot'].each do |repository|
      repository.send(:finalize!)
    end
  end
end
