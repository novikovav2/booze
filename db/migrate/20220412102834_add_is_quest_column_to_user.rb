class AddIsQuestColumnToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :isQuest, :boolean, default: false
  end
end
