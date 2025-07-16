class AddStatsToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :field_width, :integer
    add_column :games, :field_height, :integer
    add_column :games, :apples_count, :integer
    add_column :games, :barriers_count, :integer
    add_column :games, :collected_apples, :integer
    add_column :games, :duration, :integer
  end
end
