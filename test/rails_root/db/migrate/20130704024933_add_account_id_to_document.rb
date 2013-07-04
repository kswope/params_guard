class AddAccountIdToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :account_id, :int
  end
end
