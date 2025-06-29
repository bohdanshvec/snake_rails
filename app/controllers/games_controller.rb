class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update]

  def index
    # binding.irb
  end

  def create
    @game = Game.create!
    GameData.delete_old_cookies(cookies)
    # binding.irb
    redirect_to game_path(@game) #, status: :see_other
  end

  def show
    get_data_game
    @game_over = nil
    @state.save!
    # binding.irb
  end

  def update
    body = JSON.parse(request.body.read) rescue {}
    @direction = body["direction"]
    @quit = body["quit"]

    get_data_game

    @text_game_over, @game_over = ProcessGame.game_over?(@snake, @barriers, @quit)

    return if @game_over

    @snake, @turns = ProcessGame.tick!(@snake, @direction, @turns)

    # update cookies for next request
    @state.snake = @snake
    @state.turns = @turns
    @state.save!


    respond_to do |format|
      format.html { redirect_to game_path(@game) }
      format.turbo_stream
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def get_data_game
    @state = GameData.new(cookies)
    @snake = @state.snake
    @turns = @state.turns
    @barriers = @state.barriers
    @field = FieldRenderer.render_field(@snake, @barriers)
  end

end
