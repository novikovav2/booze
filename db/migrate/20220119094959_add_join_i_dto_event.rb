class AddJoinIDtoEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :join_id, :string
  end
end
