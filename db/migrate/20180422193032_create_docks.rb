class CreateDocks < ActiveRecord::Migration[5.2]
  def change
    create_table :docks do |t|
      t.belongs_to :location, foreign_key: true

      t.timestamps
    end
  end
end
