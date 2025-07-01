class RemoveCountAndFieldFromGames < ActiveRecord::Migration[8.0]
  def change
    remove_column :games, :count, :integer
    remove_column :games, :field, :text
  end
end
