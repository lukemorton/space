require_relative 'person_not_in_crew_error'
require_relative 'unknown_ship_boarding_request_error'

module Space
  module Flight
    class AcceptRequestToBoard
      Response = Struct.new(:successful?)

      def initialize(ship_boarding_request_gateway:, ship_gateway:)
        @ship_boarding_request_gateway = ship_boarding_request_gateway
        @ship_gateway = ship_gateway
      end

      def accept(ship_boarding_request_id, person_id)
        boarding_request = ship_boarding_request(ship_boarding_request_id)
        raise UnknownShipBoardingRequestError.new if boarding_request.nil?
        raise PersonNotInCrewError.new unless boarding_request.ship.has_crew_member_id?(person_id)

        ship_boarding_request_gateway.delete(ship_boarding_request_id)
        ship_gateway.add_crew_member(boarding_request.ship.id, boarding_request.requester.id)
        Response.new(true)
      end

      private

      attr_reader :ship_boarding_request_gateway,
                  :ship_gateway

      def ship_boarding_request(ship_boarding_request_id)
        ship_boarding_request_gateway.find(ship_boarding_request_id)
      end
    end
  end
end
