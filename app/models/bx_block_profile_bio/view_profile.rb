# frozen_string_literal: true

module BxBlockProfileBio
  # view profiler model
  # rubocop:disable Lint/IneffectiveAccessModifier
  class ViewProfile < BxBlockProfileBio::ApplicationRecord
    self.table_name = :view_profiles

    include Wisper::Publisher

    # belongs_to :account, class_name: 'AccountBlock::Account'
    belongs_to :viewer, foreign_key: :view_by_id, class_name: 'AccountBlock::Account'
    belongs_to :profile_bio,
               foreign_key: :profile_bio_id,
               class_name: 'BxBlockProfileBio::ProfileBio'

    after_create :create_notification

    attr_accessor :mutual_friends

    private

    def self.mutual_friend(current_account_id, profiles)
      profiles.each do |profile|
        mutual_friends = fetch_mutual_friends(profile, current_account_id, profiles)
        profile.mutual_friends = mutual_friends || []
      end
    end

    def self.fetch_mutual_friends(profile, current_account_id, _profiles)
      sender_friends = fetch_friends(profile.view_by_id)
      receiver_friends = fetch_friends(current_account_id)

      mutual_friend_ids = sender_friends.flatten.uniq - [profile.view_by_id] &
                          receiver_friends.flatten.uniq - [current_account_id]
      AccountBlock::Account.where(id: mutual_friend_ids)
    end

    def self.fetch_friends(id_to_find_with)
      BxBlockRequestManagement::Request.where(
        '(sender_id=? or account_id=?) and status=?',
        id_to_find_with, id_to_find_with, 0
      ).pluck(:account_id, :sender_id)
    end

    def create_notification
      user_account = AccountBlock::Account.find(view_by_id)
      message = "#{user_account.first_name} #{user_account.last_name} has viewed your profile"
      BxBlockPushNotifications::PushNotification.create(account_id: view_by_id,
                                                        push_notificable_type: 'AccountBlock::Account',
                                                        push_notificable_id: profile_bio.account_id,
                                                        notify_type: 'viewed_profile',
                                                        remarks: message)
    end
  end
  # rubocop:enable Lint/IneffectiveAccessModifier
end
