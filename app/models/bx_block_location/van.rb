module BxBlockLocation
  class Van < AccountBlock::ApplicationRecord
    self.table_name = :vans

    has_one :location,
            class_name: 'BxBlockLocation::Location',
            dependent: :destroy
    has_one :service_provider,
            class_name: 'BxBlockLocation::VanMember',
            dependent: :destroy, foreign_key: 'account_id'
    has_many :assistants,
             class_name: 'BxBlockLocation::VanMember',
             dependent: :destroy, foreign_key: 'account_id'
    has_many :van_members, class_name: 'BxBlockLocation::VanMember', dependent: :destroy
    has_many :reviews, as: :reviewable, class_name: 'BxBlockReviews::Review',dependent: :destroy

    has_one_attached :main_photo
    has_many_attached :galleries

    before_create :offline_van
    after_create :assign_location

    accepts_nested_attributes_for :van_members, :service_provider, :assistants

    validates :name, presence: true, uniqueness: true

    def service_provider
      BxBlockRolesPermissions::Role.find_by_name('admin').accounts.joins(
        'JOIN van_members ON van_members.account_id = accounts.id'
      ).where(
        accounts: { van_members: {van_id: self.id} }
      )
    end

    def available_vans vans
      available_service_provider = Array.new
      service_providers_for_vans(vans).each do |service_provider|
        unless contains_booked_slot_time(service_provider)
          van = BxBlockLocation::Van.joins(:van_members).where(
            'van_members.account_id = ?', service_provider.id
          ).first

          available_service_provider << van.location
        else
          next
        end
      end
      available_service_provider
    end

    private

    def contains_booked_slot_time(service_provider)
      contain_booked_slot_time = false
      get_booked_slots(get_availability(service_provider)).each do |booked_slot|
        if (booked_slot.start_time..booked_slot.end_time).cover?(Time.now) or
            (booked_slot.start_time..booked_slot.end_time).cover?(Time.now + 1.hours)
          contain_booked_slot_time = true
          break
        end
      end
      contain_booked_slot_time
    end

    def get_availability(service_provider)
       BxBlockAppointmentManagement::Availability.where(
         service_provider_id: service_provider.id,
         availability_date: Date.today.strftime('%d/%m/%y')
      ).first
    end

    def get_booked_slots(availability)
      BxBlockAppointmentManagement::BookedSlot.where(
        service_provider_id: availability.service_provider.id,
        booking_date: Date.today.strftime('%d/%m/%y')
      ).map{ |booked_slot| {
          start_time: booked_slot.start_time.to_time, end_time: booked_slot.end_time.to_time
        }
      }
    end

    def service_providers_for_vans(vans)
      BxBlockRolesPermissions::Role.find_by_name('admin').accounts.joins(
          'JOIN van_members ON van_members.account_id = accounts.id'
      ).joins(
          'JOIN availabilities ON availabilities.service_provider_id = accounts.id'
      ).where(
          'availabilities.availability_date = ?', Date.today.strftime('%d/%m/%y')
      ).joins(
          'JOIN vans on vans.id = van_members.van_id'
      ).where('vans.id = ?', vans.ids)
    end

    def assign_location
      self.create_location() unless self.location.present?
    end

    def offline_van
      self.is_offline = true
    end

  end
end
