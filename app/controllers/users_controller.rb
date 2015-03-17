class UsersController < ApplicationController
  def index
    @users = User.all

    respond_to do |format|
      format.json { render 'index', formats: :json, handlers: :jbuilder }
    end
  end

  def show
    @user = User.find(params[:id])
    @events = @user.registered_events + @user.created_events
    @notifications = @user.notifications

    respond_to do |format|
      format.html

      format.ics do
        @calendar = view_context.make_calendar(@events, request.host_with_port)
        render text: @calendar.export
      end

      format.rss
    end
  end
end
