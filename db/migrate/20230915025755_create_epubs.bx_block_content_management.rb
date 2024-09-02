# This migration comes from bx_block_content_management (originally 20210407065125)
class CreateEpubs < ActiveRecord::Migration[6.0]
  def change
    create_table :epubs do |t|
      t.string :heading
      t.text :description, size: :long
      t.timestamps
    end
  end
end
