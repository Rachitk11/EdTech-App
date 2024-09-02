# frozen_string_literal: true

module BxBlockProfileBio
  # prefences model
  class Preference < BxBlockProfileBio::ApplicationRecord
    self.table_name = :preferences

    include Wisper::Publisher
    # belongs_to :profile_bio
    belongs_to :account, class_name: 'AccountBlock::Account'

    enum smoking: %i[Yes No Sometimes], _prefix: :smoking
    enum drinking: %i[Yes No Occasionally], _prefix: :drinking
    enum religion: %i[Buddhist Christian Hindu Jain Muslim Sikh], _prefix: :religion
    enum height_type: %i[cm inches foot], _prefix: :height_type
    enum body_type: %i[Athletic Average Fat Slim], _prefix: :body_type
    enum seeking: %i[Male Female Both], _prefix: :seeking
  end
end
