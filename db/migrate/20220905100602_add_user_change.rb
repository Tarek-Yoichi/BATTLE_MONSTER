class AddUserChange < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :lived, :datetime
  end
end
