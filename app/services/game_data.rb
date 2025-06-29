class GameData
  include GameConstants
  
  GAME_KEYS = %i[snake turns apples barriers]
  BARRIERS_COUNT = 20

  attr_accessor :snake, :turns#, :apples
  attr_reader :barriers

  def initialize(cookies)
    @cookies = cookies
    @snake = JSON.parse(cookies[:snake] || snake_new, symbolize_names: true)
    @turns = JSON.parse(cookies[:turns] || "[]", symbolize_names: true)
    @barriers = JSON.parse(cookies[:barriers] || barriers_new(BARRIERS_COUNT), symbolize_names: true)
  end


  def self.delete_old_cookies(cookies)
    GAME_KEYS.each { |key| cookies.delete(key) }
  end

  def save!
    save(:snake, @snake)
    save(:turns, @turns)
    # save(:apples, @apples)
    save(:barriers, @barriers)
  end

  private

  def snake_new
   JSON.generate(
      (1..SIZE_PYTHON).map { |i| { x: (SIZE_PYTHON + 1) - i, y: 1, direction: :right } }
    )
  end

  def barriers_new(barriers_count)
    barriers_coordinate = []
    while barriers_coordinate.count < barriers_count
      barrier = { x: rand(1..FIELD_WIDTH_GAMING), y: rand(1..FIELD_HEIGHT_GAMING) }

      # Проверяем, что координаты не совпадают с телом змейки, яблоками и другими барьерами
      unless @snake.any? { |segment| segment[:x] == barrier[:x] && segment[:y] == barrier[:y] } ||
            #  apple_coordinate.any? { |existing| existing[:x] == barrier[:x] && existing[:y] == barrier[:y] } ||
                barriers_coordinate.any? { |existing| existing[:x] == barrier[:x] && existing[:y] == barrier[:y] }
        barriers_coordinate << barrier
      end
    end

    JSON.generate(barriers_coordinate)
  end

  def parse(key, default)
    JSON.parse(@cookies[key] || default.to_json, symbolize_names: true)
  rescue JSON::ParserError
    default
  end

  def save(key, value)
    @cookies[key] = JSON.generate(value)
  end

end