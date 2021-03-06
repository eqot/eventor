require 'icalendar'

class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @time = params[:t] || 'coming'
    case @time
    when 'all'
      @events = Event.visible(current_user)
    when 'passed'
      @events = Event.visible(current_user).passed.page(params[:page])
    else # when 'coming'
      @events = Event.visible(current_user).coming.page(params[:page])
    end

    @view = params[:v] || 'list'

    respond_to do |format|
      format.html
      format.json { render 'index', formats: :json, handlers: :jbuilder }
    end
  end

  def show
    @event = Event.find(params[:id])

    return unless user_signed_in?

    @ticket = current_user.tickets.find_by(event_id: params[:id])

    Notification.find_and_checked!(current_user, @event)
  end

  def new
    @event = current_user.created_events.build
    @event.build_invitation
  end

  def create
    @event = current_user.created_events.build(event_params)
    @event.convert_member_ids_to_invitees(params[:event][:members])

    if @event.save
      redirect_to @event, notice: 'Created'
    else
      render :new
    end
  end

  def edit
    @event = current_user.created_events.find(params[:id])
    @event.convert_invitees_to_member_ids
  end

  def update
    @event = current_user.created_events.find(params[:id])
    @event.convert_member_ids_to_invitees(params[:event][:members])

    if @event.update(event_params)
      redirect_to @event, notice: 'Updated'
    else
      render :new
    end
  end

  def destroy
    @event = current_user.created_events.find(params[:id])
    @event.invitation.destroy!
    @event.destroy!
    redirect_to events_path, notice: 'Deleted'
  end

  private

  def event_params
    params.require(:event).permit(
      :title, :description,
      :image_file, :image_file_cache, :remove_image_file, :image_url,
      :visibility, :members,
      invitation_attributes: [:start_time, :end_time, :location, :max_attendees, :deadline]
    )
  end
end
