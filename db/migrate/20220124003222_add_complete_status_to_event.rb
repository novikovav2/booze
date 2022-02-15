class AddCompleteStatusToEvent < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :complete, :boolean, default: false
    add_column :events, :products_complete, :boolean, default: false
  end
end
