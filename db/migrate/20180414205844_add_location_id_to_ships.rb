class AddLocationIdToShips < ActiveRecord::Migration[5.1]
  def change
    add_reference :ships, :location
  end
end
