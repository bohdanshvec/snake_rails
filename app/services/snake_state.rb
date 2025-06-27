class SnakeState

  SIZE_PYTHON = 6

  def initialize(cookies)
    @cookies = cookies
    @snake = JSON.parse(cookies[:snake] || snake_new, symbolize_names: true)
    @turns = JSON.parse(cookies[:turns] || "[]", symbolize_names: true)
  end


  def self.start(cookies)
    # Удаляем все старые куки
    cookies.each { |key, _| cookies.delete(key) }

    # Создаём и возвращаем новый экземпляр SnakeState
    new(cookies)
  end

  def save!
    save(:snake, @snake)
    save(:turns, @turns)
    # save(:apples, @apples)
    # save(:barriers, @barriers)
  end

  private

  def snake_new
   JSON.generate(
      (1..SIZE_PYTHON).map { |i| { x: (SIZE_PYTHON + 1) - i, y: 1, direction: :right } }
    )
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