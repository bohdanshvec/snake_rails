class GamesController < ApplicationController
  before_action :set_game, only: [:show, :update]

  def index
    @cookies = cookies
    @game = Game.new(
      field_width: @cookies[:field_width],
      field_height: @cookies[:field_height],
      apples_count: @cookies[:apples_count],
      barriers_count: @cookies[:barriers_count]
    )
  end

  def create
    GameData.delete_old_cookies(cookies)

    game_attributes = params[:game]&.permit(:field_width, :field_height, :apples_count, :barriers_count) || {
      field_width: 110,
      field_height: 25,
      apples_count: 30,
      barriers_count: 30
    }

    @game = Game.new(game_attributes)
    @game.user = current_user if user_signed_in?

    if @game.valid?
      cookies[:field_width]     = @game.field_width
      cookies[:field_height]    = @game.field_height
      cookies[:apples_count]    = @game.apples_count
      cookies[:barriers_count]  = @game.barriers_count

      @game.save!
      redirect_to game_path(@game)
    else
      render :index, status: :unprocessable_entity
    end
  end

  def show
    get_data_game
    @game_over = nil
    @state.save!
  end

  def update
    body = JSON.parse(request.body.read) rescue {}
    @direction = body["direction"]
    @quit = body["quit"]

    get_data_game

    @text_game_over, @game_over = ProcessGame.game_over?(@snake, @barriers, @config, @quit)

    if @game_over
      if user_signed_in?
        @game.update(
          field_width: @config.field_width,
          field_height: @config.field_height,
          apples_count: @config.apples_count,
          barriers_count: @config.barriers_count,
          collected_apples: (@snake.count - 6),
          duration: (Time.current - @game.created_at).to_i
        )
      end
      return
    end

    @snake, @turns, @apples = ProcessGame.tick!(@snake, @direction, @apples, @barriers, @config, @turns)

    # update cookies for next request
    @state.snake = @snake
    @state.turns = @turns
    @state.apples = @apples
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
    @config = GameConfig.new(cookies)
    @state = GameData.new(cookies, @config)
    @snake = @state.snake
    @turns = @state.turns
    @barriers = @state.barriers
    @apples = @state.apples
    @field = FieldRenderer.render_field(@snake, @barriers, @apples, @config)
  end
    # binding.irb
end
