class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true

  has_many :created_events, class_name: 'Event', foreign_key: :owner_id
  has_many :tickets
  has_many :registered_events, through: :tickets, source: :event

  belongs_to :target_event
end
