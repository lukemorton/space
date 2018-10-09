require_relative 'ship'

module Space
  module Flight
    class Refuel
      Response = Struct.new(:successful?)

      def initialize(money_gateway:, ship_gateway:)
        @money_gateway = money_gateway
        @ship_gateway = ship_gateway
      end

      def refuel(ship_id, refuel:)
        ship = ship_gateway.find(ship_id)

        ship_gateway.update(
          ship.id,
          fuel: refuel == 'full_tank' ? Ship::FUEL_MAX : Ship::FUEL_MAX / 2
        )

        Response.new(true)
      end

      private

      attr_reader :money_gateway
      attr_reader :ship_gateway
    end
  end
end
