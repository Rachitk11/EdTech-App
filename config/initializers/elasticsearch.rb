require 'elasticsearch/model'
Elasticsearch::Model.client = Elasticsearch::Client.new url: ENV['ELASTICSEARCH_URL'] || 'http://localhost:3000'