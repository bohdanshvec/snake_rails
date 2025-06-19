module GamesHelper
  def render_board(game)
    board = Array.new(11) { Array.new(21, ".") }

    game.state[:snake].each do |part|
      board[part[:y]][part[:x]] = "S"
    end

    apple = game.state[:apple]
    board[apple[:y]][apple[:x]] = "A"

    board.map { |row| row.join(" ") }.join("\n")
  end
end