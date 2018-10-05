class ShipPresenter < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  def fuel
    number_with_delimiter(ship.fuel)
  end

  def fuel_status
    if ship.out_of_fuel?
      'danger'
    elsif ship.low_on_fuel?
      'warning'
    else
      'success'
    end
  end

  def hull
    '100%'
  end

  def hull_status
    'success'
  end

  def shields
    '100%'
  end

  def shields_status
    'success'
  end

  def destinations
    super.map.with_index do |destination, index|
      DestinationPresenter.new(destination, index: index, ship: ship)
    end
  end

  private

  def ship
    __getobj__
  end

  class DestinationPresenter < SimpleDelegator
    def initialize(destination, index:, ship:)
      super(destination)
      @index = index
      @ship = ship
    end

    def checked?
      index == 0
    end

    def disabled?
      !destination.within_ship_fuel_range?
    end

    def fuel_to_travel_status
      if destination.just_within_ship_fuel_range?
        'warning'
      elsif destination.within_ship_fuel_range?
        'success'
      else
        'danger'
      end
    end

    private

    attr_reader :index, :ship

    def destination
      __getobj__
    end
  end
end
