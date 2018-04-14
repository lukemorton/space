class Person < ApplicationRecord
  belongs_to :location

  validates :name, presence: true
  validates :location, presence: true
end
