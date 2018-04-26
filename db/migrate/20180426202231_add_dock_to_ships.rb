class AddDockToShips < ActiveRecord::Migration[5.2]
  def change
    add_reference :ships, :dock, foreign_key: true

    reversible do |dir|
      dir.up do
        Ship.all.each do |ship|
          ship.update!(dock: ship.location.dock)
        end
      end
    end
  end
end
