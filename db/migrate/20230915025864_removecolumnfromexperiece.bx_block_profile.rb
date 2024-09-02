# This migration comes from bx_block_profile (originally 20220921073632)
# This migration comes from bx_block_profile (originally 20210806071846)
class Removecolumnfromexperiece < ActiveRecord::Migration[6.0]
  def change
    change_column :career_experiences, :add_key_achievements, :string, array: true,
                  default: [], using: "(string_to_array(add_key_achievements, ','))"
  end
end
