module BxBlockCatalogue
  class StudyMaterialSerializer < BuilderBase::BaseSerializer

    attributes :videos do |object|
	    object.videos_lectures.map { |video| 
	    	BxBlockCatalogue::VideoSerializer.new(video).serializable_hash }
	  end

	  attributes :assignments do |object|
	    object.assignments.map { |assignment| BxBlockCatalogue::AssignmentSerializer.new(assignment).serializable_hash }
	  end
  end
end
