class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @events = @user.registered_events + @user.created_events

    respond_to do |format|
      format.html

      format.ics do
        @calendar = make_calendar(@events, request.host_with_port)
        render text: @calendar.export
      end
    end
  end

  private

  def make_calendar(events, host)
    RiCal.Calendar do
      events.each do |ev|
        url = Rails.application.routes.url_helpers.event_url(ev, host: host)

        event do
          summary            ev.title
          description        ev.description
          dtstart            ev.start_time
          dtend              ev.end_time
          location           ev.place
          organizer_property ";CN=\"#{ev.owner.name}\":mailto:#{ev.owner.email}"
          uid                url
          url                url
          add_attendee       ev.attendees.collect(&:name).join(', ')
        end
      end
    end
  end
end
