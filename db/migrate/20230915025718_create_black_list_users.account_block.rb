# This migration comes from account_block (originally 20210602054437)
class CreateBlackListUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :black_list_users do |t|
      t.references :account, null: false, foreign_key: true
      t.timestamps
    end
  end
end
