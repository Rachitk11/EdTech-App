# frozen_string_literal: true
# This migration comes from bx_block_profile_bio (originally 20201223104530)

# create prefences
# rubocop:disable Metrics/MethodLength
class CreatePreferences < ActiveRecord::Migration[6.0]
  def change
    create_table :preferences do |t|
      t.integer :seeking
      t.string :discover_people, array: true
      t.text :location
      t.integer :distance
      t.string :age_range
      t.string :height
      t.integer :height_type
      t.integer :body_type
      t.integer :religion
      t.integer :smoking
      t.integer :drinking
      t.integer :profile_bio_id

      t.timestamps
    end
  end
end
# rubocop:enable Metrics/MethodLength
