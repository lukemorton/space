class Person < ApplicationRecord
  belongs_to :location
  belongs_to :user
  belongs_to :ship, required: false

  validates :name, presence: true
end
