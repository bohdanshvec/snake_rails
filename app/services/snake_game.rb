class SnakeGame
  attr_reader :snake, :direction

  def initialize(snake, direction)
    @snake = snake.deep_dup
    @direction = direction
    @snake.first[:direction] = @direction if @direction
  end

  def tick!
    move_snake
    # тут в будущем: проверка на яблоки, стены и т.д.
    self
  end

  def self.tick!(snake, direction)
    new(snake, direction).tap(&:tick!).snake
  end

  def self.game_over?
    false
  end

  private

  def move_snake
    @snake.map! { |segment| move_segment(segment) }
  end

  def move_segment(segment)
    case segment[:direction].to_sym
    when :right then segment[:x] += 1
    when :left  then segment[:x] -= 1
    when :up    then segment[:y] -= 1
    when :down  then segment[:y] += 1
    end
    segment
  end

end