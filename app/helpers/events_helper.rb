module EventsHelper
  def show_timeslot(start_time, end_time)
    start_tag   = content_tag(:span, '', class: 'datetime', data: { date: start_time.iso8601 })
    divider_tag = content_tag(:span, ' - ')
    end_tag     = content_tag(:span, '', class: 'datetime datetime-time', data: { date: end_time.iso8601 })

    start_tag + divider_tag + end_tag
  end
end
