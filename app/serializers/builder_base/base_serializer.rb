module BuilderBase
  class BaseSerializer
    include FastJsonapi::ObjectSerializer

    class << self
      private

      def base_url
        ENV['BASE_URL'] || 'http://localhost:3000'
      end
    end
  end
end
