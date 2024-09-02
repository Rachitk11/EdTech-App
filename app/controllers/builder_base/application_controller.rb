module BuilderBase
  class ApplicationController < ::ApplicationController
    include JSONAPI::Deserialization
    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    def not_found
      render :json => {'errors' => ['Record not found']}, :status => :not_found
    end
  end
end
