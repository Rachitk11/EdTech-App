# frozen_string_literal: true
# This migration comes from bx_block_order_management (originally 20201019085336)

class CreateBxBlockOrderManagementTrackings < ActiveRecord::Migration[6.0]
  def change
    create_table :trackings do |t|
      t.string :status
      t.string :tracking_number
      t.datetime :date

      t.timestamps
    end
  end
end
