class EventInvitation < ActiveRecord::Base
  belongs_to :event

  validate :start_time_should_be_before_end_time

  def iso8601
    self.start_time = start_time.iso8601
    self.end_time = end_time.iso8601
  end

  private

  def start_time_should_be_before_end_time
    return unless start_time && end_time
    return unless start_time >= end_time

    errors.add(:start_time, 'should be before end time')
  end
end
