class ShipDockServicesPresenter
  def initialize(dock_services)
    @dock_services = dock_services
  end

  def refuel_options
    dock_services.refuel_service.options.map.with_index do |option, i|
      RefuelOptionPresenter.new(option.type, option.cost, index: i)
    end
  end

  private

  attr_reader :dock_services

  class RefuelOptionPresenter
    include ActiveSupport::Inflector

    def initialize(type, cost, index:)
      @type = type
      @cost = cost
      @index = index
    end

    attr_reader :type, :index

    def cost
      @cost.format
    end

    def checked?
      index == 0
    end

    def label
      humanize(type)
    end
  end
end
