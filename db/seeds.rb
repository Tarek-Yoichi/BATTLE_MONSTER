# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require "open-uri"

Attack.destroy_all
Monster.destroy_all
User.destroy_all
Specie.destroy_all
Deck.destroy_all
Battle.destroy_all

puts "creation de personnage..."
#base_url = 'https://cloudinary.com/console/c-346c3bd548b428e163df3dca628643/media_library/folders/home'

#player1_avatar_url = URI.open("#{base_url}/defaut_avatar.png")
#player2_avatar_url = URI.open("#{base_url}/defaut_avatar.png")

player_one = User.create!(email: "thibault@battle.com", password: "123456", name: "Thibault", pc: 0)
player_two = User.create!(email: "tarek@battle.com", password: "123456", name: "Tarek", pc: 0)

#player_one.avatar.attach!(io: player1_avatar_url, filename: 'defaut_avatar.png', content_type: 'image/png')
#player_two.avatar.attach!(io: player2_avatar_url, filename: 'defaut_avatar.png', content_type: 'image/png')


puts "creation du bestiaire"

specie_one = Specie.create!(name: "golem")
specie_two = Specie.create!(name: "garou")

attack_one = Attack.create!(damage: 50, name: "jets de pierres", specie_id: specie_one.id)
attack_two = Attack.create!(damage: 50, name: "griffure sanglante", specie_id: specie_two.id)

puts "creation des stars du jeu..."
monster_one = Monster.create!(name: "Durdur", user_id: player_one.id, specie_id: specie_one.id, xp: 100)
monster_two = Monster.create!(name: "Croc", user_id: player_two.id, specie_id: specie_two.id, xp: 100)

puts "creation d'une battle + 2 decks"
battle = Battle.new(pc_win: 500, xp_win: 150, status: "pending", round: 1)
deck1 = Deck.create!(user: player_one, monster: monster_one, attack: attack_one, battle: battle, hp: 100)
_deck2 = Deck.create!(user: player_two, monster: monster_two, attack: attack_two, battle: battle, hp: 100)
battle.current_deck = deck1
battle.save!

puts "Tout a été créé avec succès !"
