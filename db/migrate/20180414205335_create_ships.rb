class CreateShips < ActiveRecord::Migration[5.1]
  def change
    create_table :ships do |t|

      t.timestamps
    end
  end
end
