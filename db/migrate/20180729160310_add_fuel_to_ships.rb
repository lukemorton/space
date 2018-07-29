class AddFuelToShips < ActiveRecord::Migration[5.2]
  def change
    add_column :ships, :fuel, :integer, null: false, default: 0
  end
end
