class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update]

  def index
    # binding.irb
  end

  def create
    @game = Game.create!
    cookies[:snake] = cookies_to_json([{ x: 6, y: 1, direction: :right }, { x: 5, y: 1, direction: :right }, { x: 4, y: 1, direction: :right }, { x: 3, y: 1, direction: :right }, { x: 2, y: 1, direction: :right }, { x: 1, y: 1, direction: :right }])
    cookies[:turns] = cookies_to_json([])
    # binding.irb
    redirect_to game_path(@game) #, status: :see_other
  end

  def show
    # binding.irb
    @snake = cookies_to_array(cookies[:snake])
    @game_over = nil
  end

  def update
    # binding.irb
    body = JSON.parse(request.body.read) rescue {}
    @direction = body["direction"]
    @quit = body["quit"]

    @snake = cookies_to_array(cookies[:snake])
    @turns = cookies_to_array(cookies[:turns])

    @text_game_over, @game_over = SnakeGame.game_over?(@snake, @quit)

    return if @game_over

    @snake, @turns = SnakeGame.tick!(@snake, @direction, @turns)

    # update cookies for next request
    cookies[:snake] = cookies_to_json(@snake)
    cookies[:turns] = cookies_to_json(@turns)

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
