class Ship < ApplicationRecord
  belongs_to :location

  has_many :crew, class_name: 'Person'
end
