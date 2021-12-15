require 'active_support/concern'
module Searchable
  extend ActiveSupport::Concern
 
  included do
    include Elasticsearch::Model
 
    index_name "articles"
 
    settings index: {
      number_of_shards: 1,
      number_of_replicas: 0
    } do
      mapping _source: { enabled: true } do
        # indexes :id, type: 'integer', index: 'not_analyzed'
        indexes :id, type: 'integer'
        indexes :title, type: 'string'
        # indexes :title, type: 'text'
        # indexes :id, type: 'long'
        indexes :body, type: 'text'
      end
    end
  end
 
  module ClassMethods
    def create_index!(options={})
      client = __elasticsearch__.client
      client.indices.delete index: "articles" rescue nil if options[:force]
      client.indices.create index: "articles",
      body: {
        settings: settings.to_hash,
        mappings: mappings.to_hash
      }
    end
  end
end
