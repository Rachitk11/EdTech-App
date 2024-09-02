# This migration comes from bx_block_settings (originally 20200930040039)
class CreateSetting < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :title
      t.string :name
    end
  end
end
