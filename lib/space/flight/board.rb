module Space
  module Flight
    class Board
      Response = Struct.new(:successful?)

      def initialize(ship_gateway:)
        @ship_gateway = ship_gateway
      end

      def board(person_id, ship_id)
        ship = ship_gateway.find(ship_id)

        unless ship.has_crew_member_id?(person_id)
          ship_gateway.add_crew_member(ship_id, person_id)
          Response.new(true)
        else
          Response.new(false)
        end
      end

      private

      attr_reader :ship_gateway
    end
  end
end
