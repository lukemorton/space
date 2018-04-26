class Dock < ApplicationRecord
  belongs_to :location
  has_many :ships, through: :location
end
