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

ActiveRecord::Schema[7.0].define(version: 2022_09_06_143148) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "attacks", force: :cascade do |t|
    t.integer "damage"
    t.string "name"
    t.bigint "specie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "success"
    t.string "attack_btn"
    t.string "attack_skin"
    t.integer "image_num"
    t.index ["specie_id"], name: "index_attacks_on_specie_id"
  end

  create_table "battles", force: :cascade do |t|
    t.integer "pc_win"
    t.integer "xp_win"
    t.string "status", default: "pending"
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
    t.integer "hp", default: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "attack_one_id"
    t.bigint "attack_two_id"
    t.bigint "attack_three_id"
    t.boolean "empty", default: true
    t.index ["battle_id"], name: "index_decks_on_battle_id"
    t.index ["monster_id"], name: "index_decks_on_monster_id"
    t.index ["user_id"], name: "index_decks_on_user_id"
  end

  create_table "monsters", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.integer "xp", default: 0
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
    t.string "monster_skin"
    t.string "monster_head"
    t.string "info"
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
    t.string "avatar", default: "https://onepage.dropagence.fr/game/bm/img/static/ugly/brou.png"
    t.integer "pc", default: 0
    t.datetime "lived"
    t.boolean "onboard", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "attacks", "species", column: "specie_id"
  add_foreign_key "battles", "decks", column: "current_deck_id"
  add_foreign_key "battles", "users", column: "winner_id"
  add_foreign_key "decks", "battles"
  add_foreign_key "decks", "monsters"
  add_foreign_key "decks", "users"
  add_foreign_key "monsters", "species", column: "specie_id"
  add_foreign_key "monsters", "users"
end
