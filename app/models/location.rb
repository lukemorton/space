class Location < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :ships
  has_many :establishments, class_name: 'Dock'

  validates :name, presence: true
  validates :slug, presence: true
  validates :coordinate_x, presence: true
  validates :coordinate_y, presence: true
  validates :coordinate_z, presence: true
end
