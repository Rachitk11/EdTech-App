module BxBlockCatalogue
  class StudentSerializer < BuilderBase::BaseSerializer
  	include FastJsonapi::ObjectSerializer
    attributes :id, :first_name, :student_unique_id

    attributes :class do |object| 
    	BxBlockCategories::SchoolClass.find_by(id: object.school_class_id).class_number rescue nil
  	end

  	attributes :division do |object| 
      BxBlockCategories::ClassDivision.find_by(id: object.class_division_id).division_name rescue nil
    end

    attributes :assignment_status do |object|
      object.assignment_status || false 
    end

    attributes :video_status do |object, params|
      object.student_videos.map do |acc|
        if acc.videos_lecture_id == params[:video_lecture_id].to_i
          BxBlockCatalogue::StudentVideo.find_by(videos_lecture_id: params[:video_lecture_id]).status 
        else
          false
        end
      end
    end

    attributes :ebook_status do |object| 
      object.ebook_status || false
    end

    attributes :assignment_complete do |object|
      object.assignment_download ||  false 
    end

    attributes :ebook_status do |object| 
      object.ebook_status || false
    end

    attributes :ebook_download do |object| 
      object.ebook_download || false
    end

    attributes :date_assigned do |object, params| 
      if params[:video_lecture_id].present?
        BxBlockCatalogue::VideosLecture.find(params[:video_lecture_id]).created_at
      elsif params[:assignment_id].present?
        BxBlockCatalogue::Assignment.find(params[:assignment_id]).created_at
      else params[:ebook_alloment_id]
        BxBlockBulkUploading::EbookAllotment.find(params[:ebook_alloment_id]).created_at
      end
    end
	end
end