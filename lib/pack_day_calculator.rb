class PackDayCalculator
  LEAD_TIME = 36.hours

  def self.first_pack_day_with_lead_time_after(time)
    first_pack_day_after(time + LEAD_TIME)
  end

  def self.first_pack_day_after(time)
    next_tuesday = first_tuesday_after(time)
    if christmas_period?(next_tuesday)
      return first_pack_day_after(next_tuesday.to_time)
    else
      return next_tuesday unless holiday?(next_tuesday)
      first_pack_day_after(time)
    end
  end

  def self.first_tuesday_after(time)
    delta = 2 - time.wday
    delta = delta + 7 if delta <= 0
    time.to_date + delta
  end

  def self.christmas_period?(tuesday)
    (date.month == 12 && date.day > 23) || (date.month == 1 && date.day < 7)
  end

  def self.holiday?(tuesday)
    australia_day?(date) || anzac_day?(date) || melbourne_cup?(date)
  end

  def self.australia_day?(tuesday)
    date.month == 1 && date.day == 26
  end

  def self.anzac_day?(tuesday)
    date.month == 4 && date.day == 25
  end

  def self.melbourne_cup?(tuesday)
    date.month == 11 && date.day <= 7
  end
end
