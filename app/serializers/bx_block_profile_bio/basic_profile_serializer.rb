# frozen_string_literal: true

# profile serializer
module BxBlockProfileBio
  # BxBlockProfileBio module
  # rubocop:disable Metrics/BlockLength, Metrics/ClassLength
  class BasicProfileSerializer < BuilderBase::BaseSerializer
    attributes(:age, :gender, :created_at, :updated_at)

    attribute :account_id, &:id

    attribute :model_name do |_object|
      'AccountBlock::Account'
    end

    attribute :full_name do |object|
      full_name_for object
    end

    attribute :address do |object|
      address_for object
    end

    attribute :about_me do |object|
      object&.profile_bio&.about_me
    end

    attribute :personality do |object|
      object&.profile_bio&.personality
    end

    attribute :interests do |object|
      object&.profile_bio&.interests
    end

    attribute :looking_for do |object|
      object.categories&.map(&:name)
    end

    attribute :distance_away_from do |object|
      distance_for object
    end

    attribute :is_liked do |object|
      like_profile_for object
    end

    attribute :is_online, &:online?

    attribute :is_favourite do |object|
      favourite_profile_for object
    end

    attribute :request_status do |object, params|
      request = begin
        object.recevied_requests.where(sender_id: params[:current_user_id]).first
      rescue StandardError
        nil
      end
      status = if request.blank?
                 'Not send the request'
               elsif request.present?
                 request.status.nil? ? 'Pending' : request.status
               else
                 'Not send the request'
               end
      status
    end

    attribute :about_business, if: proc { |object|
                                     object.categories.map(&:name).include?('business')
                                   } do |object|
      object&.profile_bio&.about_business
    end

    attribute :custom_attributes do |object|
      object&.profile_bio&.custom_attributes
    end

    attribute :educations, if: proc { |object|
                                 object.categories.map(&:name).include?('business') ||
                                   object.categories.map(&:name).include?('match_making')
                               } do |object|
      object&.profile_bio&.educations
    end

    attribute :careers, if: proc { |object|
                              object.categories.map(&:name).include?('business') ||
                                object.categories.map(&:name).include?('match_making')
                            } do |object|
      object&.profile_bio&.careers
    end

    attribute :achievements, if: proc { |object| object.categories.map(&:name).include?('business') } do |object|
      object&.profile_bio&.achievements
    end

    attribute :basic_details do |object|
      {
        date_of_birth: object&.date_of_birth,
        height: object&.profile_bio&.height,
        weight: object&.profile_bio&.weight,
        height_type: object&.profile_bio&.height_type,
        weight_type: object&.profile_bio&.weight_type,
        body_type: object&.profile_bio&.body_type,
        mother_tougue: object&.profile_bio&.mother_tougue,
        religion: object&.profile_bio&.religion,
        zodiac: object&.profile_bio&.zodiac,
        marital_status: object&.profile_bio&.marital_status,
        languages: object&.profile_bio&.languages,
        smoking: object&.profile_bio&.smoking,
        drinking: object&.profile_bio&.drinking
      }
    end

    attribute :images do |object|
      image_arr = []
      if object.images.attached?
        object.images.each do |img|
          image_hash = {
            id: img.id,
            url: Rails.application.routes.url_helpers.url_for(img)
          }
          image_arr << image_hash
        end
      end
      image_arr
    end

    attribute :friends_list do |object, params|
      sender_friends = BxBlockRequestManagement::Request.where(
        '(sender_id=? or account_id=?) and status=?', object.id, object.id, 0
      )
                                                        .pluck(:account_id, :sender_id)
      receiver_friends = BxBlockRequestManagement::Request.where(
        '(sender_id=? or account_id=?) and status=?',
        params[:current_user_id], params[:current_user_id], 0
      )
                                                          .pluck(:account_id, :sender_id)

      sender_friends = sender_friends.flatten.uniq - [object.id]
      receiver_friends = receiver_friends.flatten.uniq - [params[:current_user_id].to_i]
      mutual_friend_ids = begin
        sender_friends & receiver_friends
      rescue StandardError
        0
      end

      friends_account = AccountBlock::Account.where(id: sender_friends)
      friends_list_arr = []
      if friends_account.present?
        friends_account.each do |friend_account|
          next unless friend_account.images.attached?

          img = friend_account.images.find_by(default_image: true)
          next if img.blank?

          image_hash = {
            id: img.id,
            record_type: img.record_type,
            record_id: img.record_id,
            url: Rails.application.routes.url_helpers.url_for(img),
            default_image: img.default_image
          }

          friends_list_arr << image_hash
        end
      end
      { mutual_friends_count: mutual_friend_ids.count || 0, friends: friends_list_arr }
    end

    class << self
      private

      def like_profile_for(object)
        object.is_liked
      end

      def favourite_profile_for(object)
        object.is_favourite
      end

      def full_name_for(object)
        [object&.first_name, object&.last_name].join(' ')
      end

      def address_for(object)
        return nil if object.location.blank?

        object.location&.address
      end

      def distance_for(object)
        "#{object.distance_away || 0.0} km away"
      end
    end
  end
  # rubocop:enable Metrics/BlockLength,Metrics/ClassLength
end
