module GamesHelper  
  def duration_text(integer)
    return nil unless integer

    minutes = integer / 60
    remaining_seconds = integer % 60

    if minutes >= 1
      "#{minutes} #{ t('time.min')} #{remaining_seconds} #{ t('time.sec')}"
    else
      "#{remaining_seconds} #{ t('time.sec')}"
    end

  end
end