class Dock < ApplicationRecord
  extend FriendlyId
  friendly_id :dock_and_location_name, use: :slugged
  
  belongs_to :location
  has_many :ships
  
  def dock_and_location_name
    "Dock at #{location.name}"
  end
end
