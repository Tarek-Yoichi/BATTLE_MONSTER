class Monster < ApplicationRecord
  belongs_to :user
  belongs_to :specie
  has_many :decks

  validates :name, presence: true
  validates :xp, numericality: { only_integer: true }
end
