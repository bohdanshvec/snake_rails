class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update, :tick]

  def index
    # binding.irb
  end

  def create
    @game = Game.create!
    # binding.irb
    redirect_to game_path(@game)#, status: :see_other 
  end

  def show
    # binding.irb
  end

  def update
    @game.tick!
    respond_to do |format|
      format.html { redirect_to game_path(@game) }
      format.turbo_stream
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
