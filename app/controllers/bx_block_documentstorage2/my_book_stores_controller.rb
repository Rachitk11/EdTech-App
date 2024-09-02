
module BxBlockDocumentstorage2
	class MyBookStoresController < ApplicationController

    def show_bundle
      bundles = BxBlockBulkUploading::BundleManagement.all.page(params[:page]).per(params[:per_page])
      render json: serialize_bundles(bundles)
    end

    def show_ebooks
      account = AccountBlock::Account.find_by(id: @token.id)
      @collections = BxBlockBulkUploading::Ebook.all.page(params[:page]).per(params[:per_page])
    
      if params[:subject].present?
        @collections = @collections.where(subject: params[:subject])
      end
    
      if params[:search_term].present?
        search_term = params[:search_term].downcase
        @collections = @collections.where("LOWER(title) LIKE ? OR LOWER(author) LIKE ?", "%#{search_term}%", "%#{search_term}%")
      end
    
      if @collections.any?
        ebooks_data = @collections.map do |ebook|
          {
            id: ebook.id,
            title: ebook.title,
            author: ebook.author,
            price: ebook.price,
            subject: ebook.subject,
            cover_image_url: ebook.images.map { |image| url_for(image) }
          }
        end
    
        if account.role.name == "Student"
          ebooks_allotted_to_student = BxBlockBulkUploading::EbookAllotment.where(student_id: account.id).includes(:ebook)
          unique_alloted_ebook_ids = ebooks_allotted_to_student.pluck(:ebook_id).uniq
    
          ebooks_data.each do |ebook|
            ebook[:assigned] = unique_alloted_ebook_ids.include?(ebook[:id])
          end
        end
        subjects = BxBlockCatalogue::Subject.all
        subjects_data = subjects.map { |subject| { id: subject.id, name: subject.subject_name } }
        unique_subjects = subjects_data.uniq { |subject| subject[:name] }
        render json: { all_data: ebooks_data, subject: unique_subjects  }, status: :ok
      end
    end

    def show_one_book_details
      @ebook = BxBlockBulkUploading::Ebook.find(params[:id])

      if @ebook.present?
          render json: BxBlockBulkUploading::EbookSerializer.new(@ebook, serialization_options).serializable_hash, status: :ok
      end
    end

    def show_one_bundle_details
      bundle = BxBlockBulkUploading::BundleManagement.find(params[:id])
      render json: serialize_one_bundle(bundle)
    end

    private

    def serialize_one_bundle(bundle)
      {
        id: bundle.id,
        title: bundle.title,
        description: bundle.description,
        total_pricing: bundle.ebooks.sum(:price),
        books_count:bundle.ebooks.count,
        board: bundle.board,
        school_class_id: bundle.school_class_id,
        books: bundle.ebooks.pluck(:title),
        cover_images: bundle.cover_images.map { |image| url_for(image) }
      }
    end

    def serialize_bundles(bundles)
      bundle_data = bundles.map do |bundle|
        {
          id: bundle.id,
          title: bundle.title,
          board: bundle.ebooks.pluck(:board).uniq.join(", "),
          class: bundle.ebooks.pluck(:school_class_id).uniq.join(", "),
          total_books: bundle.ebooks.count,
          total_price: bundle.ebooks.sum(:price),
          cover_images: bundle.cover_images.map { |image| url_for(image) }
        }
      end
      {
        bundles: bundle_data,
        total_count: bundles.count
      }
      end


		def serialization_options
			{ params: { host: request.protocol + request.host_with_port } }
		end
  end
end