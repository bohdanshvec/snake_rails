class SnakeGame

  ESCAPE = 'Вы нажали ESCAPE и прервали игру!'

  attr_reader :snake, :direction, :turns

  def initialize(snake, direction, turns = [])
    @snake = snake.deep_dup
    @direction = direction.to_sym if direction
    @turns = turns
  end

  def tick!
    SnakeModules::Turns.add_turns(@snake, @direction, @turns) if @direction
    SnakeModules::PositionSnake.change_direction_segment(@snake, @turns)
    SnakeModules::Turns.delete_coordinates_turn(@snake, @turns)
    SnakeModules::PositionSnake.change_coordinates_snake(@snake)
    # тут в будущем: проверка на яблоки, стены и т.д.
    self
  end

  def self.tick!(snake, direction, turns)
    game = new(snake, direction, turns)
    game.tick!
    [game.snake, game.turns]
  end

  def self.game_over?(snake, quit = false)
    return [ESCAPE, true] if quit
    SnakeModules::GameOver.game_over?(snake)
  end

end