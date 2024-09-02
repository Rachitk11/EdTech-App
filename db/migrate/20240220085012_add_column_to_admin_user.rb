class AddColumnToAdminUser < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :school_allow, :boolean, default: false
    add_column :admin_users, :class_allow, :boolean, default: false
    add_column :admin_users, :subject_allow, :boolean, default: false
    add_column :admin_users, :assignment_allow, :boolean, default: false
    add_column :admin_users, :video_allow, :boolean, default: false
    add_column :admin_users, :account_allow, :boolean, default: false
  end
end
