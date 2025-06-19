class Game < ApplicationRecord
  FIELD_WIDTH = 100
  FIELD_HEIGHT = 25
  FIELD_WIDTH_GAMING = FIELD_WIDTH - 2
  FIELD_HEIGHT_GAMING = FIELD_HEIGHT - 4

  after_initialize :setup_default

  def setup_default
    self.count ||= 0
    self.field ||= default_field.join("\n")
  end

  def default_field
    arr = []
    arr << ("-" * FIELD_WIDTH)
    FIELD_HEIGHT_GAMING.times { arr << ("|" + " " * FIELD_WIDTH_GAMING + "|") }
    arr << ("-" * FIELD_WIDTH)
    arr
  end

  def field_array
    field.to_s.split("\n")
  end

  def tick!
    self.count += 1
    # Тут можно обновлять field, змею и т.д.
    save!
  end
end

