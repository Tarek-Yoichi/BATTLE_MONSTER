class Attack < ApplicationRecord
  belongs_to :specie
  has_many :decks

  validates :damage, numericality: { only_integer: true }
  validates :name, presence: true
end
