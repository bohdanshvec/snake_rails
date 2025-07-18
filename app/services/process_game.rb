class ProcessGame

  attr_reader :snake, :direction, :apples, :turns

  def initialize(snake, direction, apples, barriers, config, turns = [])
    @snake = snake.deep_dup
    @direction = direction.to_sym if direction
    @apples = apples
    @barriers = barriers
    @config = config
    @turns = turns
  end

  def self.message_escape        = I18n.t('messages_end.escape')
  def self.message_self      = I18n.t('messages_end.self')
  def self.message_out_of_bounds = I18n.t('messages_end.out_of_bounds')
  def self.message_barrier       = I18n.t('messages_end.barrier')
  def tick!
    ProcessModules::Turns.add_turns(@snake, @direction, @turns) if @direction
    ProcessModules::PositionSnake.change_direction_segment(@snake, @turns)

    head = @snake.first

    if @apples.any? { |a| a[:x] == head[:x] && a[:y] == head[:y] }
      @apples.delete({ x: head[:x], y: head[:y] })
      head_and_apple = head.dup
      ProcessModules::PositionSnake.change_segment_snake(head_and_apple)
      @snake.unshift(head_and_apple)
      while @apples.count < @config.apples_count
        apple = GameData.create_random_coordinate(@config)

        unless @snake.any? { |segment| segment[:x] == apple[:x] && segment[:y] == apple[:y] } ||
          @barriers.any? { |barrier| barrier[:x] == apple[:x] && barrier[:y] == apple[:y] } ||
              @apples.any? { |existing| existing[:x] == apple[:x] && existing[:y] == apple[:y] }

          @apples << apple
        end
      end
    else
      ProcessModules::Turns.delete_coordinates_turn(@snake, @turns)
      ProcessModules::PositionSnake.change_coordinates_snake(@snake)
    end

    self
  end

  def self.tick!(snake, direction, apples, barriers, config, turns)
    game = new(snake, direction, apples, barriers, config, turns)
    game.tick!
    [game.snake, game.turns, game.apples]
  end

  def self.game_over?(snake, barriers, config, quit = false)
    head = snake.first
    body = snake[1..]

    return [ProcessGame.message_escape, true] if quit
    return [ProcessGame.message_self, true] if body.any? { |s| s[:x] == head[:x] && s[:y] == head[:y] }
    return [ProcessGame.message_barrier, true] if barriers.any? { |b| b[:x] == head[:x] && b[:y] == head[:y] }
    return [ProcessGame.message_out_of_bounds, true] if head[:y] < 1 || head[:y] > (config.field_height - 2) || head[:x] < 1 || head[:x] > (config.field_width - 2)

    false
  end

end