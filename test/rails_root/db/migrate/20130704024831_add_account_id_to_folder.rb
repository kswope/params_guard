class AddAccountIdToFolder < ActiveRecord::Migration
  def change
    add_column :folders, :account_id, :int
  end
end
