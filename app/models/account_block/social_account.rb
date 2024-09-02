module AccountBlock
  class SocialAccount < Account
    include Wisper::Publisher

    validates :email, uniqueness: true, presence: true
    validates :unique_auth_id, presence: true

    after_validation :set_active

    def set_active
      self.activated = true
    end
  end
end
