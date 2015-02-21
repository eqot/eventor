class EventInvitation < ActiveRecord::Base
  belongs_to :event

  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :start_time_should_be_before_end_time

  private

  def start_time_should_be_before_end_time
    return unless start_time && end_time
    return unless start_time >= end_time

    errors.add(:start_time, 'should be before end time')
  end
end
