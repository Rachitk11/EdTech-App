class AdminUser < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable,
           :recoverable, :rememberable, :validatable

    enum role: [:super_admin, :sub_admin]
    validates_presence_of :role

    validate :school_presence_for_sub_admin

    after_create :send_email
    after_update :send_email

    
    def send_email
      AccountBlock::AdminUserMailer
      .with(account: self)
      .admin_permission_email.deliver
    end 

   

    private

    def school_presence_for_sub_admin
      if sub_admin? && school_id.blank?
          errors.add(:school_id, "must be present for sub admin")
      elsif super_admin? && school_id.present?
          errors.add(:school_id, "No need for super admin to have a school ID")
      end
    end
end
