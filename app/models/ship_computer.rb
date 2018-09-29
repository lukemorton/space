class ShipComputer < ApplicationRecord
  belongs_to :ship

  validates :reference, presence: true
end
