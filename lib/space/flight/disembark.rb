require_relative 'unknown_ship_error'

module Space
  module Flight
    class Disembark
      Response = Struct.new(:successful?, :errors)

      def initialize(ship_gateway:)
        @ship_gateway = ship_gateway
      end

      def disembark(person_id, ship_id)
        ship = ship_gateway.find(ship_id)
        raise UnknownShipError.new if ship.nil?

        if can_disembark?(ship, person_id)
          ship_gateway.remove_crew_member(ship_id, person_id)
          Response.new(true, [])
        else
          Response.new(false, ['You are not in crew. Did you disembark already?'])
        end
      end

      private

      attr_reader :ship_gateway

      def can_disembark?(ship, person_id)
        if ship.has_crew_member_id?(person_id)
          true
        else
          false
        end
      end
    end
  end
end
