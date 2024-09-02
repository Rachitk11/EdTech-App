class AddColumnToEbookAllotmnet < ActiveRecord::Migration[6.0]
  def change
    add_column :ebook_allotments, :school_class_id, :integer
    add_column :ebook_allotments, :class_division_id, :integer
    add_column :ebook_allotments, :school_id, :integer
  end
end
