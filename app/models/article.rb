require 'elasticsearch/model'

class Article < ApplicationRecord
  include Elasticsearch::Model
end

