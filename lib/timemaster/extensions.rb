module Timemaster
  module Extensions
      extend self
      
    def time_formats
      { :year   => '%Y',
        :month  => '%m',
        :day    => '%d',
        :hour   => '%H',
        :minute => '%M',
        :second => '%S'}
    end
  end
end

Timemaster::Extensions.time_formats.each do |k, v|
  Date::DATE_FORMATS.update(k => v)
  Time::DATE_FORMATS.update(k => v)
end

class Range
  ##
  # Takes a range and converts it to an array of months
  #
  # (Time.now..1.day.from_now).to_hours
  #
  def to_months
    return if first > last
    arr = []
    time = first
    while time <= last
      arr << time
      time += 1.month
    end
    return arr
  end
  ##
  # Takes a range and converts it to an array of days
  #
  # (Time.now..7.days.from_now).to_days
  #
  def to_days
    return if first > last
    arr = []
    time = first
    while time <= last
      arr << time
      time += 1.day
    end
    return arr
  end
  
  ##
  # Takes a range and converts it to an array of hours
  #
  # (Time.now..1.day.from_now).to_hours
  #
  def to_hours
    return if first > last
    arr = []
    time = first
    while time <= last
      arr << time
      time += 1.hour
    end
    return arr
  end
  
  ##
  # Takes a range and converts it to an array of minutes
  #
  # (Time.now..1.day.from_now).to_hours
  #
  def to_minutes
    return if first > last
    arr = []
    time = first
    while time <= last
      arr << time
      time += 1.minute
    end
    return arr
  end
end