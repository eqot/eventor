class NotificationsController < ApplicationController
  def index
    return false unless current_user

    @notifications = current_user.notifications
  end

  def destroy
    notification = current_user.notifications.find(params[:id])
    notification.checked!(current_user) if notification.present?
  end
end
