class GameData
  include GameConstants
  
  GAME_KEYS = %i[snake turns apples barriers]

  attr_accessor :snake, :turns, :apples
  attr_reader :barriers

  def initialize(cookies)
    @cookies = cookies
    @snake = JSON.parse(cookies[:snake] || snake_new, symbolize_names: true)
    @turns = JSON.parse(cookies[:turns] || "[]", symbolize_names: true)
    @barriers = JSON.parse(cookies[:barriers] || barriers_new, symbolize_names: true)
    @apples = JSON.parse(cookies[:apples] || apple_new, symbolize_names: true)
  end


  def self.delete_old_cookies(cookies)
    GAME_KEYS.each { |key| cookies.delete(key) }
  end

  def save!
    save(:snake, @snake)
    save(:turns, @turns)
    save(:barriers, @barriers)
    save(:apples, @apples)
  end

  private

  def snake_new
   JSON.generate(
      (1..SIZE_PYTHON).map { |i| { x: (SIZE_PYTHON + 1) - i, y: 1, direction: :right } }
    )
  end

  def barriers_new
    barriers_coordinate = []
    while barriers_coordinate.count < BARRIERS_COUNT
      barrier = GameData.create_random_coordinate

      unless @snake.any? { |segment| segment[:x] == barrier[:x] && segment[:y] == barrier[:y] } ||
            barriers_coordinate.any? { |existing| existing[:x] == barrier[:x] && existing[:y] == barrier[:y] }
        barriers_coordinate << barrier
      end
    end

    JSON.generate(barriers_coordinate)
  end

  def apple_new
    apple_coordinate = []
    while apple_coordinate.count < APPLE_COUNT
      apple = GameData.create_random_coordinate

      unless @snake.any? { |segment| segment[:x] == apple[:x] && segment[:y] == apple[:y] } ||
            @barriers.any? { |barrier| barrier[:x] == apple[:x] && barrier[:y] == apple[:y] } ||
                apple_coordinate.any? { |existing| existing[:x] == apple[:x] && existing[:y] == apple[:y] }

        apple_coordinate << apple
      end
    end

    JSON.generate(apple_coordinate)
  end

  def self.create_random_coordinate
    { x: rand(1..FIELD_WIDTH_GAMING), y: rand(1..FIELD_HEIGHT_GAMING) }
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