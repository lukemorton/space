class ShipBoardingRequest < ApplicationRecord
  belongs_to :ship
  belongs_to :requester, class_name: 'Person'
end
