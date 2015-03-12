class NotificationsController < ApplicationController
  def index
    return false unless current_user

    @notifications = current_user.notifications
  end
end
