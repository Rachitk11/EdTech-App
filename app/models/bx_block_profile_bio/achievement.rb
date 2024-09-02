# frozen_string_literal: true

module BxBlockProfileBio
  # achivement model
  class Achievement < BxBlockProfileBio::ApplicationRecord
    self.table_name = :achievements
    include Wisper::Publisher
    belongs_to :profile_bio

    URL_REGEXP = %r{^(http|https)://[a-z0-9]+([\-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?$}i.freeze
    validates :url,
              format: {
                with: URL_REGEXP,
                message: 'is invalid,
                format example: http/https://www.test.com',
                multiline: true
              }, allow_blank: true
  end
end
