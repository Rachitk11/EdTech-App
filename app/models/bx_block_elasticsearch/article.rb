require "searchkick"
module BxBlockElasticsearch
	class BxBlockElasticsearch::Article < ApplicationRecord
	   Searchkick.client_type = :elasticsearch
	    #Searchkick.client_type = :elasticsearch or :opensearch
	   searchkick
	end
end
