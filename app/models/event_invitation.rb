class EventInvitation < ActiveRecord::Base
  belongs_to :event

  validates :max_attendees, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :start_time_should_be_before_end_time

  private

  def start_time_should_be_before_end_time
    return unless start_time && end_time
    return unless start_time >= end_time

    errors.add(:start_time, 'should be before end time')
  end
end
