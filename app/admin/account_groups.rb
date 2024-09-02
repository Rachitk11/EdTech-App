module AccountGroups
  class Load
    @@loaded_from_gem = false
    def self.is_loaded_from_gem
      @@loaded_from_gem
    end

    def self.loaded
    end

    # Check if this file is loaded from gem directory or not
    # The gem directory looks like
    # /template-app/.gems/gems/bx_block_custom_user_subs-0.0.7/app/admin/subscription.rb
    # if it has block's name in it then it's a gem
    @@loaded_from_gem = Load.method(:loaded).source_location.first.include?("bx_block_")
  end
end

unless AccountGroups::Load.is_loaded_from_gem
  ActiveAdmin.register BxBlockAccountGroups::Group do
    permit_params :name, :settings, :account_ids

    index do
      selectable_column
      id_column
      column :name
      column :settings
      column :account_ids
      actions
    end

    filter :name
    filter :created_at

    form do |f|
      f.inputs do
        f.input :name
        f.input :settings
        f.input :account_ids
      end
      f.actions
    end
  end
end
