class ShipPresenter
  include ActionView::Helpers::NumberHelper

  attr_reader :computers, :locations, :ship

  def initialize(computers:, locations:, ship:)
    @computers = computers
    @locations = locations
    @ship = ship
  end

  def ship_fuel
    number_with_delimiter(ship.fuel)
  end

  def ship_fuel_status
    if ship.fuel > 10
      'success'
    elsif ship.fuel > 0
      'warning'
    else
      'danger'
    end
  end

  def ship_hull
    '100%'
  end

  def ship_hull_status
    'success'
  end

  def ship_shields
    '100%'
  end

  def ship_shields_status
    'success'
  end
end
