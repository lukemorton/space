class Location < ApplicationRecord
  has_many :establishments, class_name: 'Dock'
  has_one :dock

  validates :name, presence: true
end
