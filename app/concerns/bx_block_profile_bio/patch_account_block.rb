# frozen_string_literal: true

# rubocop:disable Style/GlobalVars
module BxBlockProfileBio
  # patch account block
  module PatchAccountBlock
    extend ActiveSupport::Concern

    included do
      attr_accessor :distance_away, :is_favourite, :is_liked

      enum gender: %i[Male Female Trans-gender], _prefix: :gender

      has_one :profile_bio, class_name: 'BxBlockProfileBio::ProfileBio', dependent: :destroy
      has_one :location, as: :locationable, class_name: 'BxBlockLocation::Location', dependent: :destroy
      has_and_belongs_to_many :categories, join_table: :account_categories, class_name: 'BxBlockCategories::Category'
      has_one :preference, class_name: 'BxBlockProfileBio::Preference', dependent: :destroy

      def online?
        $redis_onlines.exists?(id)
      end
    end
  end
end
# rubocop:enable Style/GlobalVars
