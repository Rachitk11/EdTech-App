module BxBlockProfile
  class Profile < ApplicationRecord
    self.table_name = :bx_block_profile_profiles
   
    has_one_attached :photo
    has_one_attached :profile_video
    belongs_to :account, class_name: "AccountBlock::Account"
    # has_one :current_status, dependent: :destroy, class_name: "BxBlockProfile::CurrentStatus"
    # accepts_nested_attributes_for :current_status, allow_destroy: true
    # has_one :publication_patent,dependent: :destroy, class_name: "BxBlockProfile::PublicationPatent"
    # accepts_nested_attributes_for :publication_patent, allow_destroy: true
    # has_many :awards, dependent: :destroy, class_name: "BxBlockProfile::Award"
    # accepts_nested_attributes_for :awards, allow_destroy: true
    # has_many :hobbies, dependent: :destroy, class_name: "BxBlockProfile::Hobby"
    # accepts_nested_attributes_for :hobbies, allow_destroy: true
    # has_many :courses, dependent: :destroy, class_name: "BxBlockProfile::Course"
    # accepts_nested_attributes_for :courses, allow_destroy: true
    # has_many :test_score_and_courses,dependent: :destroy, class_name: "BxBlockProfile::TestScoreAndCourse"
    # accepts_nested_attributes_for :test_score_and_courses, allow_destroy: true
    # has_many :career_experiences,dependent: :destroy, class_name: "BxBlockProfile::CareerExperience"
    # accepts_nested_attributes_for :career_experiences, allow_destroy: true
    # has_one :video, class_name: "BxBlockVideolibrary::Video"
    # has_many :educational_qualifications, dependent: :destroy,class_name: "BxBlockProfile::EducationalQualification"
    # accepts_nested_attributes_for :educational_qualifications, allow_destroy: true
    # has_many :projects,dependent: :destroy, class_name: "BxBlockProfile::Project"
    # accepts_nested_attributes_for :projects, allow_destroy: true
    # has_many :languages, class_name: "BxBlockProfile::Language"
    # has_many :contacts, class_name: "BxBlockContactsintegration::Contact"
    # has_many :jobs, class_name: "BxBlockJobListing::Job"
    # has_many :applied_jobs, class_name: "BxBlockJobListing::AppliedJob"
    # has_many :follows, class_name: "BxBlockJobListing::Follow"
    # has_many :company_pages, through: :follows , class_name: "BxBlockJoblisting::CompanyPage"
    # has_many :interview_schedules, class_name: "BxBlockCalendar::InterviewSchedule"
   # has_and_belongs_to_many :company_pages, dependent: :destroy,
                            #class_name: "BxBlockJobListing::CompanyPage",
                          #  join_table: :profiles_company_pages
    #validates :profile_role, presence: true
    # enum profile_role: [:jobseeker, :recruiter]
    # validate :profile_validation

    # Added associations for qr code and profile bio
    # has_one :qr_code, as: :qrable, class_name: "BxBlockQrCodes::QrCode"
    # has_one :profile_bio, class_name: "BxBlockProfileBio::ProfileBio"
    # accepts_nested_attributes_for :profile_bio
    # accepts_nested_attributes_for :qr_code

    # serialize :user_profile_data, Hash
 
    # after_initialize do
    #   self.user_profile_data ||= {}
    # end

    # if ActiveRecord::Base.connection&.table_exists?('bx_block_profile_custom_user_profile_fields')
    #   def self.custom_user_profile_field_names
    #     BxBlockProfile::CustomUserProfileFields.all&.pluck(:name)
    #   end

    #   store_accessor :user_profile_data, *custom_user_profile_field_names

    #   BxBlockProfile::CustomUserProfileFields.all&.each do |column|
    #     define_method column.name do
    #       user_profile_data[column.name]
    #     end

    #     define_method "#{column.name}=" do |value|
    #       user_profile_data[column.name] = value
    #     end
    #   end
    # end rescue nil


  # def reload_custom_fields
  #   custom_user_profile_fields = BxBlockProfile::CustomUserProfileFields.all&.pluck(:name)
  #   custom_user_profile_fields.each do |name|
  #   unless self.user_profile_data[name].present?
  #   # store_accessor :user_profile_data, name
  #    self.class.send(:define_method, name) do
  #       user_profile_data[name]
  #     end
  #     self.class.send(:define_method, "#{name}=") do |value|
  #       user_profile_data[name] = value
  #     end
  #  end
     
  #   end
  # end
   
    # private

    # def profile_validation
    #   if account && account.profiles.count > 2
    #     errors.add(:profiles, "for an account can not exceed count of 2")
    #   end
    # end

    # def photo_present?
    #   errors.add(:photo, :blank) unless photo.attached?
    # end

  end
end


