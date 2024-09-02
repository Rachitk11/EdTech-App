class AddTimeInHoursIntoVideoUpload < ActiveRecord::Migration[6.0]
  def change
  	add_column :videos_uploads, :time_hour, :integer
  	add_column :videos_uploads, :time_min, :integer
  end
end
