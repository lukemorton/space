class Ship < ApplicationRecord
  belongs_to :dock
  belongs_to :location

  has_many :crew, class_name: 'Person'
end
