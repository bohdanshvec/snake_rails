module ProcessModules
  module PositionSnake
    def self.change_coordinates_snake(snake)
      snake.map! { |segment| self.change_segment_snake(segment) }
    end

    def self.change_segment_snake(segment)
      case segment[:direction].to_sym
      when :right then segment[:x] += 1
      when :left  then segment[:x] -= 1
      when :up    then segment[:y] -= 1
      when :down  then segment[:y] += 1
      end
      segment
    end

    # меняем направление у сегментов, которые совпадают с поворотами
    def self.change_direction_segment(snake, turns)
      snake.each do |segment|
        turns.each do |turn|
          if segment[:x] == turn[:x] && segment[:y] == turn[:y]
            segment[:direction] = turn[:direction]
          end 
        end 
      end
    end
  end
end