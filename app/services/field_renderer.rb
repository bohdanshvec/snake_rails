class FieldRenderer

  APPLE      = '🍏'
  BARRIER    = '🧱'
  FIELD      = '⬜'
  SNAKE_BODY = '🟢'
  SNAKE_HEAD = '🐲'
  FRAME      = 2

  def self.default_field(config)
    arr = []
    arr << (BARRIER * config.field_width)
    (config.field_height - FRAME).times { arr << (BARRIER + FIELD * (config.field_width - FRAME) + BARRIER) }
    arr << (BARRIER * config.field_width)
    arr
  end

  def self.render_field(snake, barriers, apples, config)

    arr_print = default_field(config).map(&:dup)
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
