class Dock < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :location
  has_many :ships

  validates :name, presence: true
  validates :slug, presence: true
end
