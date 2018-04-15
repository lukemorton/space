class Person < ApplicationRecord
  belongs_to :location
  belongs_to :ship

  validates :name, presence: true
end
