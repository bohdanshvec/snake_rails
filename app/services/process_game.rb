class ProcessGame
  include GameConstants
  
  ESCAPE = 'Ви натиснули ESCAPE та вийшли з гри!'
  SELF = 'Ви догнали своє тіло!' 
  OUT_OF_BOUNDS = 'Ви вийшли за поле!'
  BARRIER = 'Ви врізалися в перешкоду!'

  attr_reader :snake, :direction, :apples, :turns

  def initialize(snake, direction, apples, barriers, turns = [])
    @snake = snake.deep_dup
    @direction = direction.to_sym if direction
    @apples = apples
    @barriers = barriers
    @turns = turns
  end

  def tick!
    ProcessModules::Turns.add_turns(@snake, @direction, @turns) if @direction
    ProcessModules::PositionSnake.change_direction_segment(@snake, @turns)

    head = @snake.first

    if @apples.any? { |a| a[:x] == head[:x] && a[:y] == head[:y] }
      @apples.delete({ x: head[:x], y: head[:y] })
      head_and_apple = head.dup
      ProcessModules::PositionSnake.change_segment_snake(head_and_apple)
      @snake.unshift(head_and_apple)
      while @apples.count < APPLE_COUNT
        apple = GameData.create_random_coordinate

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

  def self.tick!(snake, direction, apples, barriers, turns)
    game = new(snake, direction, apples, barriers, turns)
    game.tick!
    [game.snake, game.turns, game.apples]
  end

  def self.game_over?(snake, barriers, quit = false)
    head = snake.first
    body = snake[1..]

    return [ESCAPE, true] if quit
    return [SELF, true] if body.any? { |s| s[:x] == head[:x] && s[:y] == head[:y] }
    return [BARRIER, true] if barriers.any? { |b| b[:x] == head[:x] && b[:y] == head[:y] }
    return [OUT_OF_BOUNDS, true] if head[:y] < 1 || head[:y] > FIELD_HEIGHT_GAMING || head[:x] < 1 || head[:x] > FIELD_WIDTH_GAMING

    false
  end

end