class Event < ActiveRecord::Base
  enum visibility: { everyone: 10, members_only: 20 }

  has_many :tickets
  has_many :attendees, through: :tickets, source: :user

  has_many :targets
  has_many :invitees, through: :targets, source: :user
  attr_accessor :members

  has_one :invitation, class_name: EventInvitation
  accepts_nested_attributes_for :invitation, allow_destroy: true

  belongs_to :owner, class_name: 'User'
  delegate :name, to: :owner, prefix: true

  has_many :notifications, as: :content

  mount_uploader :image_file, FileUploader

  validates :title, presence: true

  default_scope do
    includes(:owner, :targets, :attendees, :invitation)
      .order('event_invitations.start_time')
  end
  scope :coming, lambda {
    where('event_invitations.start_time > ?', Time.now)
      .order('event_invitations.start_time')
  }
  scope :passed, lambda {
    where('event_invitations.start_time < ?', Time.now)
      .reorder('event_invitations.start_time desc')
  }
  scope :visible, lambda { |user|
    if user.present?
      where('visibility is ? OR visibility = ? OR owner_id = ? OR targets.user_id = ?',
            nil, Event.visibilities[:everyone], user.id, user.id)
    else
      where('visibility is ? OR visibility = ?',
            nil, Event.visibilities[:everyone])
    end
  }

  def image?
    image_file? || image_url?
  end

  def image
    image_file_url || image_url
  end

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

  def include?(user)
    owner == user || attend?(user)
  end

  def convert_invitees_to_member_ids
    self.members = invitees.map(&:id).join(',')
  end

  def invite!(user)
    targets.find_or_create_by!(user_id: user.id)

    user.notifications.create(
      description: I18n.t('view.notification.invited', event: title),
      content: self
    )
  end

  def uninvite!(user)
    target = targets.find_by!(user_id: user.id)
    target.destroy!

    Notification.find_and_checked!(user, self)
  end

  def convert_member_ids_to_invitees(members)
    old_ids = invitees.map(&:id)
    new_ids = members.present? ? members.split(',').map(&:to_i) : []

    added_ids = []
    new_ids.each do |id|
      added_ids.push id if old_ids.index(id).nil?
    end
    added_ids.each do |id|
      user = User.find(id)
      invite!(user) if user.present?
    end

    removed_ids = []
    old_ids.each do |id|
      removed_ids.push id if new_ids.index(id).nil?
    end
    removed_ids.each do |id|
      user = User.find(id)
      uninvite!(user) if user.present?
    end
  end
end
