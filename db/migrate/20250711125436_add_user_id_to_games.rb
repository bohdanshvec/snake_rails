class AddUserIdToGames < ActiveRecord::Migration[8.0]
  def change
    add_reference :games, :user, foreign_key: true
  end
end
