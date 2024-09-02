# This migration comes from bx_block_navmenu (originally 20200924132246)
class CreateNavigationMenu < ActiveRecord::Migration[6.0]
  def change
    create_table :navigation_menus do |t|
      t.string :position,
             comment: 'Where will this navigation item be present'
      t.json :items,
             comment: 'Navigation Menu Items, combination of url and name'
      t.timestamps
    end
  end
end
