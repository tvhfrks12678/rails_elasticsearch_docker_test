class Article < ActiveRecord::Base
  include Searchable
  def self.search_body_match(keyword)
    if keyword.present?
      query = {
        "query": {
          "match": {
            "body": keyword
          }
        }
      }
      Article.__elasticsearch__.search(query)
    else
      Article.none
    end
  end

  def self.search_body(keyword)
    if keyword.present?
      query = {
        "query": {
          "wildcard": {
              "body.keyword": "*#{keyword}*"
          }
        },
        "_source": ["title","body"]
      }
      Article.__elasticsearch__.search(query)
    else
      Article.none
    end    
  end
end
