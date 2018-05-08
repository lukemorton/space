class Location < ApplicationRecord
  has_many :ships
  has_many :establishments, class_name: 'Dock'

  validates :name, presence: true
end
