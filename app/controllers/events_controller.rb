require 'icalendar'

class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @time = params[:t] || 'coming'
    case @time
    when 'all'
      @events = Event.includes(:owner, :attendees, :invitation)
                .order('event_invitations.start_time')
    when 'passed'
      @events = Event.includes(:owner, :attendees, :invitation)
                .where('event_invitations.start_time < ?', Time.now)
                .order('event_invitations.start_time desc')
                .page(params[:page])
    else # when 'coming'
      @events = Event.includes(:owner, :attendees, :invitation)
                .where('event_invitations.start_time > ?', Time.now)
                .order('event_invitations.start_time')
                .page(params[:page])
    end

    @view = params[:v] || 'list'

    respond_to do |format|
      format.html
      format.json { render 'index', formats: :json, handlers: :jbuilder }
    end
  end

  def show
    @event = Event.find(params[:id])
    @ticket = current_user && current_user.tickets.find_by(event_id: params[:id])
  end

  def new
    @event = current_user.created_events.build
    @event.build_invitation
  end

  def create
    @event = current_user.created_events.build(event_params)
    if @event.save
      redirect_to @event, notice: 'Created'
    else
      render :new
    end
  end

  def edit
    @event = current_user.created_events.find(params[:id])
    @event.invitation.iso8601
  end

  def update
    @event = current_user.created_events.find(params[:id])
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
      :title, :description, :image, :image_cache, :remove_image, :image_url,
      invitation_attributes: [:start_time, :end_time, :location]
    )
  end
end
