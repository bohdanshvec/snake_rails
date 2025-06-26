class Game < ApplicationRecord
  FIELD_WIDTH = 130
  FIELD_HEIGHT = 28
  FIELD_WIDTH_GAMING = FIELD_WIDTH - 2
  FIELD_HEIGHT_GAMING = FIELD_HEIGHT - 4

  def default_field
    arr = []
    arr << ("-" * FIELD_WIDTH)
    FIELD_HEIGHT_GAMING.times { arr << ("|" + " " * FIELD_WIDTH_GAMING + "|") }
    arr << ("-" * FIELD_WIDTH)
    arr
  end

  def field_array(cookies_snake)
    arr_print = default_field.map(&:dup)
    cookies_snake.each_with_index do |coord, index|
      x = coord[:x]
      y = coord[:y]

      # Заменяем пробел в строке `arr[y]` на символ 'o' на позиции x
      if index == 0
        arr_print[y][x] = "s"
      else
        arr_print[y][x] = "o"
      end
    end
    arr_print
  end

end

