class Game < ApplicationRecord

  belongs_to :user, optional: true
  
  validates :field_width, numericality: { only_integer: true, greater_than_or_equal_to: 10, less_than_or_equal_to: 200 }
  validates :field_height, numericality: { only_integer: true, greater_than_or_equal_to: 5, less_than_or_equal_to: 50 }

  validates :apples_count, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    allow_nil: true
  }
  validates :barriers_count, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    allow_nil: true
  }

  validate :check_apples_and_barriers_limit

  def initialize(attributes = {})
    super
    self.field_width    = field_width.to_i
    self.field_height   = field_height.to_i
    self.apples_count   = apples_count.presence&.to_i
    self.barriers_count = barriers_count.presence&.to_i
  end

  private

  def check_apples_and_barriers_limit
    return if field_width.blank? || field_height.blank?

    max_allowed = (field_width * field_height * 0.02).floor

    if apples_count.present? && apples_count > max_allowed
      errors.add(:apples_count, "не може бути більше ніж 2% від площі поля (макс #{max_allowed})")
    end

    if barriers_count.present? && barriers_count > max_allowed
      errors.add(:barriers_count, "не може бути більше ніж 2% від площі поля (макс #{max_allowed})")
    end
  end
end


