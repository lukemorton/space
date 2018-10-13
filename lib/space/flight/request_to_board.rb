require_relative 'unknown_ship_error'

module Space
  module Flight
    class RequestToBoard
      Response = Struct.new(:successful?, :errors)

      def initialize(ship_boarding_request_gateway:, ship_gateway:)
        @ship_boarding_request_gateway = ship_boarding_request_gateway
        @ship_gateway = ship_gateway
      end

      def request_to_board(ship_id, person_id)
        ship = ship_gateway.find(ship_id)
        raise UnknownShipError.new if ship.nil?

        if can_board_ship?(ship, person_id)
          ship_boarding_request_gateway.create_request(ship.id, person_id)
          Response.new(true, [])
        else
          Response.new(false, ['You are already in crew. Did you board already?'])
        end
      end

      private

      attr_reader :ship_boarding_request_gateway,
                  :ship_gateway

      def can_board_ship?(ship, person_id)
        if ship.has_crew_member_id?(person_id)
          false
        else
          true
        end
      end
    end
  end
end
