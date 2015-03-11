module CalendarHelper
  def make_calendar(events, host)
    RiCal.Calendar do
      events.each do |ev|
        url = Rails.application.routes.url_helpers.event_url(ev, host: host)

        event do
          summary            ev.title
          description        ev.description
          dtstart            ev.invitation.start_time
          dtend              ev.invitation.end_time
          location           ev.invitation.location
          organizer_property ";CN=\"#{ev.owner.name}\":mailto:#{ev.owner.email}"
          uid                url
          url                url
          add_attendee       ev.attendees.collect(&:name).join(', ')
        end
      end
    end
  end
end
