class ShipDockServicesPresenter
  def initialize(dock_services)
    @dock_services = dock_services
  end

  def refuel_options
    dock_services.refuel_service.options.map.with_index do |option, i|
      RefuelOptionPresenter.new(option, index: i)
    end
  end

  def refuel_disabled?
    refuel_options.all?(&:disabled?)
  end

  private

  attr_reader :dock_services

  class RefuelOptionPresenter
    include ActiveSupport::Inflector

    def initialize(option, index:)
      @option = option
      @index = index
    end

    def type
      option.type
    end

    def cost
      option.cost.format
    end

    def cost_status
      option.affordable_for_person? ? 'success' : 'danger'
    end

    def checked?
      index == 0
    end

    def disabled?
      !option.affordable_for_person?
    end

    def label
      humanize(type)
    end

    private

    attr_reader :option, :index
  end
end
