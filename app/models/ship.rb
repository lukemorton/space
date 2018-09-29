class Ship < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :dock
  belongs_to :location

  has_many :crew, class_name: 'Person'
  has_many :computers, class_name: 'ShipComputer'

  validates :fuel, presence: true
  validates :name, presence: true
  validates :slug, presence: true
end
