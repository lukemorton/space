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
      false
    end

    private

    attr_reader :index, :ship

    def destination
      __getobj__
    end
  end
end
