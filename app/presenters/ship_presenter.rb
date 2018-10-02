class ShipPresenter < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  def fuel
    number_with_delimiter(ship.fuel)
  end

  def fuel_status
    if ship.fuel > 10
      'success'
    elsif ship.fuel > 0
      'warning'
    else
      'danger'
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
    super.map do |destination|
      DestinationPresenter.new(destination, ship: ship)
    end
  end

  private

  def ship
    __getobj__
  end

  class DestinationPresenter < SimpleDelegator
    def initialize(destination, ship:)
      super(destination)
      @ship = ship
    end

    def checked?
      destination.id == ship.location.id
    end

    def disabled?
      destination.id == ship.location.id
    end

    private

    attr_reader :ship

    def destination
      __getobj__
    end
  end
end
