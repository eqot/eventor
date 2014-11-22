class Event < ActiveRecord::Base

  belongs_to :owner, class_name: 'User'
  delegate :name, to: :owner, prefix: true

  validates :title, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :place, presence: true
  validate :start_time_should_be_before_end_time

  def owner?(user)
    return false unless user
    owner_id == user.id
  end

  private

  def start_time_should_be_before_end_time
    return unless start_time && end_time

    if start_time >= end_time
      errors.add(:start_time, 'should be before end time')
    end
  end

end
