class CreateMonsters < ActiveRecord::Migration[7.0]
  def change
    create_table :monsters do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.integer :xp
      t.references :specie, null: false, foreign_key: true

      t.timestamps
    end
  end
end
