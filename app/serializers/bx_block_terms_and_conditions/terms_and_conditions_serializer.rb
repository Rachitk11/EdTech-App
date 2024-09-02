module BxBlockTermsAndConditions
  class TermsAndConditionsSerializer < BuilderBase::BaseSerializer
    attributes(:id, :description, :created_at)

    attributes :accepted_by do |object|
      arr = []
      user_terms_data = object.get_accepted_accounts

      user_terms_data.each do |user_terms|
        arr << {
          account_id: user_terms["account_id"],
          accepted_on: user_terms["updated_at"],
          email: user_terms["email"]
        }
      end
      arr || []
    end
  end
end
