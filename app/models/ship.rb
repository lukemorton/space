class Ship < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :dock
  belongs_to :location

  has_many :crew, class_name: 'Person'

  validates :name, presence: true
end
