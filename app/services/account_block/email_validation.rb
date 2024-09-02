module AccountBlock
  class EmailValidation
    include ActiveModel::Validations

    attr_reader :email

    class << self
      def regex
        /[^@]+@\S+[.]\S+/
      end

      def regex_string
        regex.to_s.sub("(?-mix:", "").delete_suffix(")")
      end
    end

    validates :email, format: {
      with: regex,
      multiline: true
    }

    def initialize(email)
      @email = email
    end
  end
end
