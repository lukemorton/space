class Location < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :ships
  has_many :establishments, class_name: 'Dock'

  validates :name, presence: true
end
