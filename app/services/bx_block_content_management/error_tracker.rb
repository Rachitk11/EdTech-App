module BxBlockContentManagement
  class ErrorTracker
    def initialize
      @errors = []
    end

    def add_errors(errors)
      @errors.push(*errors)
    end

    def error?
      @errors.any?
    end

    def success?
      !error?
    end

    def get_errors
      @errors
    end
  end
end
