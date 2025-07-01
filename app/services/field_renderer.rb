class FieldRenderer
  include GameConstants

  def self.default_field
    arr = []
    arr << ("-" * FIELD_WIDTH)
    FIELD_HEIGHT_GAMING.times { arr << ("|" + " " * FIELD_WIDTH_GAMING + "|") }
    arr << ("-" * FIELD_WIDTH)
    arr
  end

  def self.render_field(snake, barriers, apples)
    arr_print = default_field.map(&:dup)
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