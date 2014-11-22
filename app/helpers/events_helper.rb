module EventsHelper

  def show_timeslot(start_time, end_time)
    timeslot = start_time.strftime('%Y/%m/%d %H:%M') + ' - ' + end_time.strftime('%Y/%m/%d %H:%M')
    content_tag(:span, timeslot)
  end

end
