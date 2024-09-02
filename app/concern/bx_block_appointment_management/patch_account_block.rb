# frozen_string_literal: true

module BxBlockAppointmentManagement
  module PatchAccountBlock
    extend ActiveSupport::Concern
    included do
      has_many :availabilities, foreign_key: :service_provider_id, class_name: "BxBlockAppointmentManagement::Availability"
    end
  end
end
