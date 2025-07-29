class FieldRenderer
  include GameConstants

  APPLE      = '🍏'
  BARRIER    = '🧱'
  FIELD      = '⬜'
  SNAKE_BODY = '🟢'
  SNAKE_HEAD = '🐲'

  def self.default_field
    arr = []
    arr << (BARRIER * FIELD_WIDTH)
    FIELD_HEIGHT_GAMING.times { arr << (BARRIER + FIELD * FIELD_WIDTH_GAMING + BARRIER) }
    arr << (BARRIER * FIELD_WIDTH)
    arr
  end

  def self.render_field(snake, barriers, apples)
    arr_print = default_field.map(&:dup)
    snake.each_with_index do |coord, index|
      x = coord[:x]
      y = coord[:y]
      arr_print[y][x] = index.zero? ? SNAKE_HEAD : SNAKE_BODY
    end

    barriers.each do |barrier|
      x = barrier[:x]
      y = barrier[:y]
      arr_print[y][x] = BARRIER
    end

    apples.each do |apple|
      x = apple[:x]
      y = apple[:y]
      arr_print[y][x] = APPLE
    end

    arr_print
  end
end
