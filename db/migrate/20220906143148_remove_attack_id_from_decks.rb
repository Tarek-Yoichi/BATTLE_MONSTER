class RemoveAttackIdFromDecks < ActiveRecord::Migration[7.0]
  def change
    remove_column :decks, :attack_id
  end
end
