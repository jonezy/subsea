module TimeHelpers
  def time
    start = Time.now
    yield
    @finish = Time.now - start
  end

  def get_ticks_for_display_from_time(time_string)
    ticks = "seconds"
    ticks = "minutes" if time_string > 60

    return ticks
  end

  def format_time_for_display(time_string)
    time_string = time_string / 60 if time_string > 60

    time_string = (time_string * 100).round / 100.0		

    return time_string
  end  
end
