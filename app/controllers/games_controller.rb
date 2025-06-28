class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update]

  def index
  end

  def create
    @game = Game.create!
    SnakeState.start(cookies).save!
    # binding.irb
    redirect_to game_path(@game) #, status: :see_other
  end

  def show
    state = SnakeState.new(cookies)
    @snake = state.snake
    @game_over = nil
    # binding.irb
  end

  def update
    body = JSON.parse(request.body.read) rescue {}
    @direction = body["direction"]
    @quit = body["quit"]

    state = SnakeState.new(cookies)
    @snake = state.snake
    @turns = state.turns

    @text_game_over, @game_over = SnakeGame.game_over?(@snake, @quit)

    return if @game_over

    @snake, @turns = SnakeGame.tick!(@snake, @direction, @turns)

    # update cookies for next request
    state.snake = @snake
    state.turns = @turns
    state.save!

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
