module BxBlockBulkUploading
  class EbookAssignsController < ApplicationController
		before_action :validate_json_web_token, only: [:ebook_assign]

		def ebook_assign
			book_id = params[:ebook_id]
			student_ids = params[:student_ids]

				student_ids.each do |student_id|
					student = AccountBlock::Account.find(student_id)
					school_class_id = student.school_class_id
					class_division_id = student.class_division_id
					school_id = student.school_id
					BxBlockBulkUploading::EbookAllotment.create!(
						account_id: @token.id,
						student_id: student_id,
						ebook_id: book_id,
						alloted_date: Date.today,
						school_class_id: school_class_id,
						class_division_id: class_division_id,
						school_id: school_id
					)
				end
				render json: { message: "Book assigned successfully to #{student_ids.length} students" }, status: :ok

				# render json: { 'message': 'Book assigned successfully' }, status: :ok
		end
  end
end