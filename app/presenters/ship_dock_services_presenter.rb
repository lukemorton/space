class ShipDockServicesPresenter < SimpleDelegator
  def initialize(current_person)
    @current_person
  end

  def refuel_options
    [
      RefuelOptionPresenter.new(:full_tank, Money.new(300_00), current_person: current_person, index: 0),
      RefuelOptionPresenter.new(:half_tank, Money.new(150_00), current_person: current_person, index: 1)
    ]
  end

  private

  attr_reader :current_person

  class RefuelOptionPresenter
    include ActiveSupport::Inflector

    def initialize(type, cost, current_person:, index:)
      @type = type
      @cost = cost
      @current_person = current_person
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
