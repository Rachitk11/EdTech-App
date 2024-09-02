module BxBlockLanguageOptions
  class ApplicationMessage < ApplicationRecord
    self.table_name = :application_messages

    translates :message, touch: true

    validates :name, presence: true, uniqueness: {case_sensitive: false}
    translation_class.validates :message,
                                presence: { message: "EN translation message can't be blank" },
                                if: -> (trans) { trans.locale == :en }

    accepts_nested_attributes_for :translations, allow_destroy: true

    def self.translation_message(key)
      application_message = BxBlockLanguageOptions::ApplicationMessage.find_by(name: key)
      if application_message.present?
        return application_message.message if application_message.message.present?
        "Translation not present for key: #{key}, locale: #{Globalize.locale()}"
      else
        "Translation not present for key: #{key}"
      end
    end

    def self.set_message_for(key, locale, message)
      application_message = BxBlockLanguageOptions::ApplicationMessage.find_by(name: key)
      if application_message.present?
        application_message.update!(locale: locale, message: message)
      else
        raise "Translation not present for key: #{key}"
      end
    end
  end
end
