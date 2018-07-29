require_relative 'cannot_board_error'

module Space
  module Flight
    class Board
      Response = Struct.new(:successful?)

      def initialize(ship_gateway:)
        @ship_gateway = ship_gateway
      end

      def board(person_id, ship_id)
        ship = ship_gateway.find(ship_id)

        if can_board_ship?(ship, person_id)
          ship_gateway.add_crew_member(ship_id, person_id)
          Response.new(true)
        else
          raise Space::Flight::CannotBoardError.new
        end
      end

      private

      attr_reader :ship_gateway

      def can_board_ship?(ship, person_id)
        if ship.nil?
          false
        elsif ship.has_crew_member_id?(person_id)
          false
        else
          true
        end
      end
    end
  end
end
