class RemoveUnusedColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :username
    remove_column :events, :complete
    remove_column :events, :products_complete
  end
end
