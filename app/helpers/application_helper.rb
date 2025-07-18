module ApplicationHelper
  def flag_for(locale)
    case locale.to_sym
    when :uk
      "🇺🇦"
    when :en
      "🇬🇧"
    else
      "🏳️"
    end
  end
end
