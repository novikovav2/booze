class AddUniqueIndexJoinIdEvents < ActiveRecord::Migration[6.1]
  def change
    add_index :events, [:join_id], unique: true
  end
end
