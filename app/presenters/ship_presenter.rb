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

  private

  def ship
    __getobj__
  end
end
