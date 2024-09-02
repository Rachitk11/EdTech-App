module AccountBlock
  class EmailAccount < Account
    ActiveSupport.run_load_hooks(:email_account, self)
    include Wisper::Publisher
    validates :email, presence: true
  end
end
