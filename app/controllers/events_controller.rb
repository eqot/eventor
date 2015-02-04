require 'icalendar'

class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @time = params[:t] || 'coming'
    case @time
    when 'all'
      @events = Event.includes(:owner, :attendees)
                .all.order(:start_time).page(params[:page])
    when 'passed'
      @events = Event.includes(:owner, :attendees)
                .where('start_time < ?', Time.now).order('start_time desc').page(params[:page])
    else # when 'coming'
      @events = Event.includes(:owner, :attendees)
                .where('start_time > ?', Time.now).order(:start_time).page(params[:page])
    end

    @view = params[:v] || 'list'

    ga_track_event('Events', 'index', @view, params[:page])

    respond_to do |format|
      format.html
      format.json { render 'index', formats: :json, handlers: :jbuilder }
    end
  end

  def show
    ga_track_event('Events', 'show', params[:id])

    @event = Event.find(params[:id])
    @ticket = current_user && current_user.tickets.find_by(event_id: params[:id])
  end

  def new
    ga_track_event('Events', 'new')

    @event = current_user.created_events.build
  end

  def create
    ga_track_event('Events', 'create')

    @event = current_user.created_events.build(event_params)
    if @event.save
      redirect_to @event, notice: 'Created'
    else
      render :new
    end
  end

  def edit
    ga_track_event('Events', 'edit', params[:id])

    @event = current_user.created_events.find(params[:id])
    @event.iso8601
  end

  def update
    ga_track_event('Events', 'update', params[:id])

    @event = current_user.created_events.find(params[:id])
    if @event.update(event_params)
      redirect_to @event, notice: 'Updated'
    else
      render :new
    end
  end

  def destroy
    ga_track_event('Events', 'destroy', params[:id])

    @event = current_user.created_events.find(params[:id])
    @event.destroy!
    redirect_to events_path, notice: 'Deleted'
  end

  private

  def event_params
    params.require(:event).permit(
      :title, :description, :start_time, :end_time, :place, :image_url, :file, :file_cache, :remove_file
    )
  end
end
