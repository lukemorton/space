class Location < ApplicationRecord
  validates :name, presence: true
end
