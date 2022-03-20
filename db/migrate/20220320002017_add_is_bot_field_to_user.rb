class AddIsBotFieldToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :isBot, :boolean, default: false
  end
end
