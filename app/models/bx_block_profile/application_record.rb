# frozen_string_literal: true

module BxBlockProfile
  class ApplicationRecord < BuilderBase::ApplicationRecord
    self.abstract_class = true
    self.table_name = 'bx_block_profile_application_records'
  end
end
