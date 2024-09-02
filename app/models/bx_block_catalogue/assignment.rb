require 'searchkick'
module BxBlockCatalogue
  class Assignment < BxBlockCatalogue::ApplicationRecord
    self.table_name = :assignments
    include Searchkick
    
    has_one_attached :assignment
    belongs_to :subject_management, class_name: "BxBlockCatalogue::SubjectManagement", optional: true
		validates_presence_of :title, :description, :assignment

		validate :assignment_file_format

	  private

	  def assignment_file_format
	    return unless assignment.attached?

	    unless assignment.blob.content_type.in?(%w[application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document])
	      errors.add(:assignment, 'must be a PDF or DOC file')
	    end
	  end
  end
end
