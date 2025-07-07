class GameConfig
  DEFAULTS = {
    field_width: 110,
    field_height: 25,
    barriers_count: 30,
    apples_count: 30,
    size_python: 6
  }

  def initialize(cookies)
    @cookies = cookies
  end

  def field_width
    (@cookies[:field_width] || DEFAULTS[:field_width]).to_i
  end

  def field_height
    (@cookies[:field_height] || DEFAULTS[:field_height]).to_i
  end

  def apples_count
    (@cookies[:apple_count] || DEFAULTS[:apples_count]).to_i
  end

  def barriers_count
    (@cookies[:barriers_count] || DEFAULTS[:barriers_count]).to_i
  end

  def size_python
    (@cookies[:size_python] || DEFAULTS[:size_python]).to_i
  end
end