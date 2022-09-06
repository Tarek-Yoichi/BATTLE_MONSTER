class AddImageNumToAttack < ActiveRecord::Migration[7.0]
  def change
    add_column :attacks, :image_num, :integer
  end
end
