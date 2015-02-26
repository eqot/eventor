class Event < ActiveRecord::Base
  enum visibility: { everyone: 10, members_only: 20 }
  has_many :members, source: :user
  serialize :members
  # before_save :interpret_members

  has_many :tickets
  has_many :attendees, through: :tickets, source: :user

  has_one :invitation, class_name: EventInvitation
  accepts_nested_attributes_for :invitation, allow_destroy: true

  belongs_to :owner, class_name: 'User'
  delegate :name, to: :owner, prefix: true

  mount_uploader :image_file, FileUploader

  validates :title, presence: true

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

  private

  def interpret_members
    ids = self.members.split(',')

    self.members = []
    ids.each do |id|
      user = User.find(id.to_i)
      if user.present?
        self.members.push(user)
      end
    end

    puts 'start'
    puts self.members
    puts 'end'
  end
end
