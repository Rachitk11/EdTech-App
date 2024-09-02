# This migration comes from bx_block_content_management (originally 20210624083016)
class CreateExams < ActiveRecord::Migration[6.0]
  def change
    create_table :exams do |t|
      t.string :heading
      t.text :description, size: :long
      t.date :to
      t.date :from
      t.timestamps
    end
  end
end
