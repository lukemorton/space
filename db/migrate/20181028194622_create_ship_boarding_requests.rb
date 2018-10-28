class CreateShipBoardingRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :ship_boarding_requests do |t|
      t.references :ship
      t.references :requester
    end
  end
end
