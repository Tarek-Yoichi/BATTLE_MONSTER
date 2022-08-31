# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_08_31_092706) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attacks", force: :cascade do |t|
    t.integer "damage"
    t.string "name"
    t.bigint "specie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["specie_id"], name: "index_attacks_on_specie_id"
  end

  create_table "battles", force: :cascade do |t|
    t.integer "pc_win"
    t.integer "xp_win"
    t.string "status"
    t.bigint "winner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "current_deck_id"
    t.integer "round", default: 0
    t.index ["current_deck_id"], name: "index_battles_on_current_deck_id"
    t.index ["winner_id"], name: "index_battles_on_winner_id"
  end

  create_table "decks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "monster_id", null: false
    t.bigint "battle_id", null: false
    t.bigint "attack_id", null: false
    t.integer "hp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attack_id"], name: "index_decks_on_attack_id"
    t.index ["battle_id"], name: "index_decks_on_battle_id"
    t.index ["monster_id"], name: "index_decks_on_monster_id"
    t.index ["user_id"], name: "index_decks_on_user_id"
  end

  create_table "monsters", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.integer "xp"
    t.bigint "specie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["specie_id"], name: "index_monsters_on_specie_id"
    t.index ["user_id"], name: "index_monsters_on_user_id"
  end

  create_table "species", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "avatar"
    t.integer "pc"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "attacks", "species", column: "specie_id"
  add_foreign_key "battles", "decks", column: "current_deck_id"
  add_foreign_key "battles", "users", column: "winner_id"
  add_foreign_key "decks", "attacks"
  add_foreign_key "decks", "battles"
  add_foreign_key "decks", "monsters"
  add_foreign_key "decks", "users"
  add_foreign_key "monsters", "species", column: "specie_id"
  add_foreign_key "monsters", "users"
end
