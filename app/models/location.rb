class Location < ApplicationRecord
  has_one :dock
  has_many :ships
  has_many :establishments, class_name: 'Dock'

  validates :name, presence: true
end
