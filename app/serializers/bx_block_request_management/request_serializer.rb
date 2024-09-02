module BxBlockRequestManagement
  class RequestSerializer < BuilderBase::BaseSerializer
    attributes(:sender_id, :status, :rejection_reason, :request_text, :created_at, :updated_at)

    attribute :reviewer_group_id do |object|
      object.account_group_id
    end

    attribute :sender_full_name do |object|
      [object.sender&.first_name, object.sender&.last_name].join(" ")
    end
  end
end
