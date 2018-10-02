class ShipPresenter < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  def ship_fuel
    number_with_delimiter(fuel)
  end

  def ship_fuel_status
    if fuel > 10
      'success'
    elsif fuel > 0
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
