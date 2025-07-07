class GameData
  
  GAME_KEYS = %i[snake turns apples barriers field_width field_height apples_count barriers_count size_python]

  attr_accessor :snake, :turns, :apples
  attr_reader :barriers

  def initialize(cookies, config)
    @config = config
    @cookies = cookies
    @snake = JSON.parse(cookies[:snake] || snake_new(@config), symbolize_names: true)
    @barriers = JSON.parse(cookies[:barriers] || barriers_new(@config), symbolize_names: true)
    @turns = JSON.parse(cookies[:turns] || "[]", symbolize_names: true)
    @apples = JSON.parse(cookies[:apples] || apple_new(@config), symbolize_names: true)
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

  def snake_new(config)
   JSON.generate(
      (1..config.size_python).map { |i| { x: (config.size_python + 1) - i, y: 1, direction: :right } }
    )
  end

  def barriers_new(config)
    barriers_coordinate = []
    while barriers_coordinate.count < config.barriers_count
      barrier = GameData.create_random_coordinate(config)

      unless @snake.any? { |segment| segment[:x] == barrier[:x] && segment[:y] == barrier[:y] } ||
            barriers_coordinate.any? { |existing| existing[:x] == barrier[:x] && existing[:y] == barrier[:y] }
        barriers_coordinate << barrier
      end
    end

    JSON.generate(barriers_coordinate)
  end

  def apple_new(config)
    apple_coordinate = []
    while apple_coordinate.count < config.apples_count
      apple = GameData.create_random_coordinate(config)

      unless @snake.any? { |segment| segment[:x] == apple[:x] && segment[:y] == apple[:y] } ||
            @barriers.any? { |barrier| barrier[:x] == apple[:x] && barrier[:y] == apple[:y] } ||
                apple_coordinate.any? { |existing| existing[:x] == apple[:x] && existing[:y] == apple[:y] }

        apple_coordinate << apple
      end
    end

    JSON.generate(apple_coordinate)
  end

  def self.create_random_coordinate(config)
    { x: rand(1..(config.field_width - 2)), y: rand(1..(config.field_height - 2)) }
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