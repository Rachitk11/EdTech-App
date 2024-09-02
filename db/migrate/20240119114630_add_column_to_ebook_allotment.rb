class AddColumnToEbookAllotment < ActiveRecord::Migration[6.0]
  def change
    add_column :ebook_allotments, :student_id, :bigint
  end
end

