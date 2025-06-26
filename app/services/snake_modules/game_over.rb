module SnakeModules
  module GameOver
    SELF = 'Вы врезались в тело змеи!'
    OUT_OF_BOUNDS = 'Вы вышли за поле!'

    def self.game_over?(snake)
      head = snake.first
      body = snake[1..]

      return [SELF, true] if body.any? { |s| s[:x] == head[:x] && s[:y] == head[:y] }
      # return :barrier if @barrier_coordinate.any? { |b| b[:x] == head[:x] && b[:y] == head[:y] }
      return [OUT_OF_BOUNDS, true] if head[:y] < 1 || head[:y] > 28 || head[:x] < 1 || head[:x] > 130

      false
    end
  end
end