class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update]

  def index
    # binding.irb
  end

  def create
    @game = Game.create!
    cookies[:snake] = cookies_to_json([{ x: 1, y: 1, direction: :right }])
    # binding.irb
    redirect_to game_path(@game)#, status: :see_other 
  end

  def show
    # binding.irb
    @snake = array_snake
  end

  def update
    @snake = array_snake
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
