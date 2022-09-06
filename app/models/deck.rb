class Deck < ApplicationRecord
  belongs_to :user
  belongs_to :monster, optional: true
  belongs_to :battle, optional: true
  # attacks
  belongs_to :attack, optional: true
  belongs_to :attack_one, optional: true, class_name: "Attack"
  belongs_to :attack_two, optional: true, class_name: "Attack"
  belongs_to :attack_three, optional: true, class_name: "Attack"

  has_one :current_battle, foreign_key: :current_deck_id, class_name: "Battle", dependent: :nullify
  validates :hp, numericality: { only_integer: true }, presence: true
end
