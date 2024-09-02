# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength, Lint/ConstantDefinitionInBlock
# patch account block
module BxBlockProfileBio
  # patch account block validator
  module PatchUpdateAccountValidator
    extend ActiveSupport::Concern
    included do
      ATTRIBUTES = [
        [:first_name],
        [:last_name],
        %i[new_phone_number full_phone_number],
        %i[new_password password],
        %i[new_email email], [:activated], [:gender], [:age], [:date_of_birth], [:category_ids]
      ].freeze

      attr_accessor(*ATTRIBUTES.map(&:first))

      def initialize(account_id, params, image_data = {})
        @account_id = account_id
        @current_password = params[:current_password]
        @image_data = image_data
        if @image_data.present?
          @image_content_type = @image_data['content_type']
          attach_image
        end
        params.each_key do |key|
          send "#{key}=", params[key]
        end
      end

      private

      def attach_image
        decoded_data = Base64.decode64(@image_data['data'].split(',')[1])
        account.images.attach(
          io: StringIO.new(decoded_data),
          content_type: @image_data['content_type'],
          filename: @image_data['filename']
        )
      end

      def image_validation
        return unless account.images.attached? && @image_data.present?

        if %w[image/jpeg image/jpg image/png].exclude?(@image_content_type)
          account.images.last.purge
          errors.add(:The_profile, 'photo cannot be updated, the image is of unsupported type.')
          return
        end
        set_default_image
      end

      def set_default_image
        new_img = account.images.last
        new_img.update(default_image: true)
        ActiveStorage::Attachment.where(
          record_type: 'AccountBlock::Account', record_id: account.id
        ).where('id != ?', new_img.id).update(default_image: false)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength, Lint/ConstantDefinitionInBlock
