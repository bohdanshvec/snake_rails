class FieldRenderer

  def self.default_field(config)
    arr = []
    arr << ("-" * config.field_width)
    (config.field_height - 2).times { arr << ("|" + " " * (config.field_width - 2) + "|") }
    arr << ("-" * config.field_width)
    arr
  end

  def self.render_field(snake, barriers, apples, config)

    arr_print = default_field(config).map(&:dup)
    snake.each_with_index do |coord, index|
      x = coord[:x]
      y = coord[:y]
      arr_print[y][x] = index.zero? ? 's' : 'o'
    end

    barriers.each do |barrier|
      x = barrier[:x]
      y = barrier[:y]
      arr_print[y][x] = '#'
    end

    apples.each do |apple|
      x = apple[:x]
      y = apple[:y]
      arr_print[y][x] = '@'
    end

    arr_print
  end
end