module GamesHelper  
  def duration_text(integer)
    return nil unless integer

    minutes = integer / 60
    remaining_seconds = integer % 60

    if minutes >= 1
      "#{minutes} хв #{remaining_seconds} сек"
    else
      "#{remaining_seconds} сек"
    end

  end
end