class Event < ActiveRecord::Base
  before_save :convert_member_ids_to_invitees

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

  mount_uploader :image_file, FileUploader

  validates :title, presence: true

  default_scope -> {
    includes(:owner, :attendees, :invitation)
    .order('event_invitations.start_time')
  }
  scope :coming, -> {
    where('event_invitations.start_time > ?', Time.now)
    .order('event_invitations.start_time')
  }
  scope :passed, -> {
    where('event_invitations.start_time < ?', Time.now)
    .reorder('event_invitations.start_time desc')
  }

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
    owner == user || self.attend?(user)
  end

  def convert_invitees_to_member_ids
    self.members = self.invitees.map(&:id).join(',')
  end

  def convert_member_ids_to_invitees
    return unless self.members.present?

    old_ids = self.invitees.map(&:id)
    new_ids = self.members.split(',').map {|item| item.to_i}

    added_ids = []
    new_ids.each do |id|
      if old_ids.index(id).nil?
        added_ids.push id
      end
    end
    added_ids.each do |id|
      targets.find_or_create_by!(user_id: id)
    end

    removed_ids = []
    old_ids.each do |id|
      if new_ids.index(id).nil?
        removed_ids.push id
      end
    end
    removed_ids.each do |id|
      target = targets.find_by!(user_id: id)
      target.destroy!
    end
  end
end
