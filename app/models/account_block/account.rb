require 'searchkick'
module AccountBlock
  class Account < AccountBlock::ApplicationRecord
    ActiveSupport.run_load_hooks(:account, self)
    self.table_name = :accounts
    include Searchkick

    include Wisper::Publisher

    validates :pin, format: { with: /\A\d{4}\z/, message: "must be a 4-digit integer" }, on: :update, if: Proc.new{|object| object.pin.present?}

    EMAIL_REGEX = /\w+@\w+.{1}[a-zA-Z]{2,}/

    # before_validation :valid_phone_number
    has_one_attached :photo
    before_create :generate_api_key
    has_one :blacklist_user, class_name: "AccountBlock::BlackListUser", dependent: :destroy
    has_many :user_terms_and_conditions,
      class_name: "BxBlockTermsAndConditions::UserTermAndCondition",
      dependent: :destroy, foreign_key: :account_id
    has_many :terms_and_conditions, through: :user_terms_and_conditions
    after_save :set_black_listed_user
    belongs_to :role, class_name: "BxBlockRolesPermissions::Role"
    belongs_to :school, class_name: "BxBlockCategories::School", optional: true
    has_one :profile, class_name: "BxBlockProfile::Profile", dependent: :destroy
    has_many :subjects, class_name: "BxBlockCatalogue::Subject"
    belongs_to :class_division, class_name: "BxBlockCategories::ClassDivision", optional: true
    has_many :subject_managements, class_name: "BxBlockCatalogue::SubjectManagement"
    
    has_many :ebook_allotments, class_name: "BxBlockBulkUploading::EbookAllotment", foreign_key: "account_id"
    has_many :ebooks, class_name: "BxBlockBulkUploading::Ebook",through: :ebook_allotments
    has_many :student_videos, class_name: 'BxBlockCatalogue::StudentVideo'
    has_many :videos_lectures, through: :student_videos, class_name: "BxBlockCatalogue::VideosLecture"

    enum status: %i[regular suspended deleted]
    enum user_type: {student: 'Student', teacher: 'Teacher', publisher: 'Publisher', school_admin: 'School Admin'}

    scope :active, -> { where(activated: true) }
    scope :existing_accounts, -> { where(status: ["regular", "suspended"]) }

    validates_presence_of :first_name, :full_phone_number
    validates_presence_of :email, if: Proc.new{|obj| ["Publisher", "Teacher", "School Admin"].include?(obj&.role&.name)}
    validates_presence_of :guardian_email, if: Proc.new{|obj| obj&.role&.name == "Student"}

    validates_format_of :email, with: EMAIL_REGEX, if: Proc.new{|obj| obj.email.present?}
    validates_format_of :guardian_email, with: EMAIL_REGEX, if: Proc.new{|obj| obj.guardian_email.present?}
    validates_uniqueness_of :email, if: Proc.new{|obj| obj.email.present?}   
    validates_uniqueness_of :bank_account_number, if: Proc.new{|obj| obj.bank_account_number.present?}
    validates_presence_of :student_unique_id, if: Proc.new{|obj| obj.role&.name == "Student"}
    validates_presence_of :teacher_unique_id, if: Proc.new{|obj| obj.role&.name == "Teacher"}
    validates :teacher_unique_id, uniqueness: {scope: :school_id}, if: Proc.new{|obj| obj.teacher_unique_id.present?}
    # validates_uniqueness_of :guardian_email, if: Proc.new{|object| object.guardian_email.present?}
    validates :student_unique_id, uniqueness: {scope: :school_id}, if: Proc.new{|obj| obj.student_unique_id.present?}
    validates_length_of :full_phone_number, is: 10
    validates_format_of :ifsc_code, with:  /\A[a-zA-Z0-9]+\z/, if: Proc.new{|object| object&.role&.name == "Publisher"}
    validates :bank_account_number, numericality: {only_numeric: true}, if: Proc.new{|object| object&.role&.name == "Publisher"}
    validates_length_of :bank_account_number, maximum: 20, if: Proc.new{|object| object&.role&.name == "Publisher"}
    validates_length_of :ifsc_code, maximum: 15, if: Proc.new{|object| object&.role&.name == "Publisher"}
    
    private

    # def parse_full_phone_number
    #   phone = Phonelib.parse(full_phone_number)
    #   self.full_phone_number = phone.sanitized
    #   self.country_code = phone.country_code
    #   self.phone_number = phone.raw_national
    # end

    # def valid_phone_number
    #   unless Phonelib.valid?(full_phone_number)
    #     errors.add(:full_phone_number, "Invalid or Unrecognized Phone Number")
    #   end
    # end

    after_create :send_mail
    
    def send_mail
      AccountBlock::EmailValidationMailer
      .with(account: self)
      .activation_email.deliver
    end

    def generate_api_key
      loop do
        @token = SecureRandom.base64.tr("+/=", "Qrt")
        break @token unless Account.exists?(unique_auth_id: @token)
      end
      self.unique_auth_id = @token
    end

    def set_black_listed_user
      if is_blacklisted_previously_changed?
        if is_blacklisted
          AccountBlock::BlackListUser.create(account_id: id)
        else
          blacklist_user.destroy
        end
      end
    end
  end
end
