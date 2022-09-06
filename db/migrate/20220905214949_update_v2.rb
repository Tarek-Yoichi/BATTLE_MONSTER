class UpdateV2 < ActiveRecord::Migration[7.0]
  def change
    add_column :species, :monster_skin, :string
    add_column :species, :monster_head, :string
    add_column :species, :info, :string

    remove_foreign_key :decks, :attacks
    add_column :decks, :attack_one_id, :bigint
    add_column :decks, :attack_two_id, :bigint
    add_column :decks, :attack_three_id, :bigint
    change_column :decks, :hp, :integer, default: 100
    add_column :decks, :empty, :boolean, default: true

    add_column :attacks, :success, :integer
    add_column :attacks, :attack_btn, :string
    add_column :attacks, :attack_skin, :string

    change_column :users, :pc, :integer, default: 0
    change_column :users, :avatar, :string, default: "https://onepage.dropagence.fr/game/bm/img/static/ugly/brou.png"
    add_column :users, :onboard, :boolean, default: false

    change_column :battles, :status, :string, default: "pending"
    change_column :monsters, :xp, :integer, default: 0
  end
end
