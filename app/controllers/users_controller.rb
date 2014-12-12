class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @events = @user.registered_events

    @calendar = makeCalendar(@events, request.host_with_port)
    puts @calendar.export

    respond_to do |format|
      format.html

      format.ics do
        render text: @calendar.export
      end
    end
  end

  def makeCalendar(events, host)
    cal = RiCal.Calendar do
      events.each do |ev|
        organizer = ";CN=\"#{ev.owner.name}\":mailto:#{ev.owner.email}"
        url = Rails.application.routes.url_helpers.event_url(ev, host: host)
        attendees = (ev.attendees.collect { |attendee| attendee.name }).join(', ')

        event do
          summary            ev.title
          description        ev.description
          dtstart            ev.start_time
          dtend              ev.end_time
          location           ev.place
          organizer_property organizer
          uid                url
          url                url
          add_attendee       attendees
        end
      end
    end
  end
end
