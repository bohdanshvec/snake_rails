module ProcessModules
  module Turns

    def self.add_turns(snake, direction, turns)
      direction_head = snake.first[:direction].to_sym

      return if direction_head == direction

      if direction == :right && direction_head != :left ||
          direction == :left && direction_head != :right ||
          direction == :up && direction_head != :down ||
          direction == :down && direction_head != :up
        self.add_turns_coordinate(snake, direction, turns)
      end
    end

    def self.add_turns_coordinate(snake, direction, turns)
      turns << { x: snake.first[:x], y: snake.first[:y], direction: direction }
    end
    
    def self.delete_coordinates_turn(snake,turns)
      turns.reject! do |turn|
        last = snake.last
        last[:x] == turn[:x] && last[:y] == turn[:y] && last[:direction] == turn[:direction]
      end
    end
  end
end