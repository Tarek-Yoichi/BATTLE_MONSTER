class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :monsters
  has_one_attached :avatar
  has_many :monsters, dependent: :destroy
  has_many :decks, dependent: :destroy
  validates :name, presence: true
end
