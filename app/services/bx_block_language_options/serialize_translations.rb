module BxBlockLanguageOptions
  class SerializeTranslations
    class << self

      def call(application_messages)
        serialized_hash = {}
        application_messages.find_each do |application_message|
          serialized_hash[application_message.name] = application_message.message
        end
        serialized_hash
      end
    end
  end
end
