module EventsHelper
  def show_timeslot(start_time, end_time)
    timeslot = start_time.strftime('%m/%d/%Y %H:%M') + ' - ' + end_time.strftime('%H:%M')
    content_tag(:span, timeslot)
  end
end
