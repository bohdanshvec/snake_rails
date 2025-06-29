class ProcessGame
  include GameConstants
  
  ESCAPE = 'Ви натиснули ESCAPE та вийшли з гри!'
  SELF = 'Ви догнали своє тіло!'
  OUT_OF_BOUNDS = 'Ви вийшли за поле!'
  BARRIER = 'Ви врізалися в перешкоду!'

  attr_reader :snake, :direction, :turns

  def initialize(snake, direction, turns = [])
    @snake = snake.deep_dup
    @direction = direction.to_sym if direction
    @turns = turns
  end

  def tick!
    ProcessModules::Turns.add_turns(@snake, @direction, @turns) if @direction
    ProcessModules::PositionSnake.change_direction_segment(@snake, @turns)
    ProcessModules::Turns.delete_coordinates_turn(@snake, @turns)
    ProcessModules::PositionSnake.change_coordinates_snake(@snake)
    self
  end

  def self.tick!(snake, direction, turns)
    game = new(snake, direction, turns)
    game.tick!
    [game.snake, game.turns]
  end

  def self.game_over?(snake, barriers, quit = false)
    head = snake.first
    body = snake[1..]

    return [ESCAPE, true] if quit
    return [SELF, true] if body.any? { |s| s[:x] == head[:x] && s[:y] == head[:y] }
    return [BARRIER, true] if barriers.any? { |b| b[:x] == head[:x] && b[:y] == head[:y] }
    return [OUT_OF_BOUNDS, true] if head[:y] < 1 || head[:y] > FIELD_HEIGHT || head[:x] < 1 || head[:x] > FIELD_WIDTH

    false
  end

end