module BxBlockDashboard
  class CandidateSerializer < BuilderBase::BaseSerializer
  
    # attribute :total_candidates do |object, params|
    #   total_candidates = params[:total_candidates]
    # end
    attribute :total_candidates do |object| 
      
      object.sub_attributres.map{|p| p.values.map{|p| p.to_i}}.flatten.sum
    end
    attribute :sub_attributres do |object|
      object.sub_attributres
    end
  end
end

