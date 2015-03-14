class Notification < ActiveRecord::Base
  has_many :user_notifications
  has_many :users, through: :user_notifications, source: :user

  default_scope do
    order('created_at desc')
  end

  def notify!(user)
    return false unless user

    user_notifications.find_or_create_by!(user_id: user.id)
  end

  def checked!(user)
    return false unless user

    user_notifications.find_by(user_id: user.id).destroy
  end

  def self.find_and_checked!(user, event)
    return false unless user

    notification = user.notifications.find_by(url: event.base_url)
    notification.checked!(user) if notification.present?
  end
end
