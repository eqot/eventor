class TicketsController < ApplicationController
  before_action :store_current_location
  before_action :authenticate_user!

  def create
    ticket = current_user.tickets.build do |t|
      t.event_id = params[:event_id]
    end

    if ticket.save
      event = Event.find(params[:event_id])
      redirect_to event_path(event)
    else
      render json: { message: ticket.errors.full_message }, status: 422
    end
  end

  def destroy
    ticket = current_user.tickets.find_by!(event_id: params[:event_id])
    if ticket.destroy!
      event = Event.find(params[:event_id])
      redirect_to event_path(event)
    else
      render json: { message: ticket.errors.full_message }, status: 422
    end
  end

  private

  def store_current_location
    event = Event.find(params[:event_id])
    store_location_for(:user, event_path(event))
  end
end
