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
    @game_over = nil
  end

  def update
    # binding.irb
    @snake = array_snake
    @direction = read_direction
    @snake = SnakeGame.tick!(@snake, @direction)
    @game_over = SnakeGame.game_over?

    # update_coordinates_snake
    update_cookies_snake(@snake)
    respond_to do |format|
      format.html { redirect_to game_path(@game) }
      format.turbo_stream
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def read_direction
    JSON.parse(request.body.read)["direction"] rescue nil
  end

end
