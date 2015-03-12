class Notification < ActiveRecord::Base
  has_many :user_notifications
  has_many :users, through: :user_notifications, source: :user

  def notify!(user)
    return false unless user

    user_notifications.find_or_create_by!(user_id: user.id)
  end

  def checked!(user)
    return false unless user
    
    user_notifications.find_by(user_id: user.id).destroy
  end
end
