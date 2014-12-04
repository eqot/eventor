class Event < ActiveRecord::Base
  has_many :tickets
  has_many :attendees, through: :tickets, source: :user

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

  def attend?(user)
    return false unless user
    tickets.find_by(user_id: user.id)
  end

  def attend!(user)
    tickets.find_or_create_by!(user_id: user.id)
  end

  def to_ics(host)
    event = Icalendar::Event.new
    event.dtstart       = self.start_time.strftime("%Y%m%dT%H%M%S")
    event.dtend         = self.end_time.strftime("%Y%m%dT%H%M%S")
    event.summary       = self.title
    event.description   = self.description
    event.location      = self.place
    event.ip_class      = "PUBLIC"
    event.created       = self.created_at
    event.last_modified = self.updated_at
    event.uid = event.url = Rails.application.routes.url_helpers.event_url(self, host: host)
    event.organizer     = 'mailto:' + self.owner.email

    cal = Icalendar::Calendar.new
    cal.add_event(event)
    cal.to_ical
  end

  private

  def start_time_should_be_before_end_time
    return unless start_time && end_time

    if start_time >= end_time
      errors.add(:start_time, 'should be before end time')
    end
  end
end
