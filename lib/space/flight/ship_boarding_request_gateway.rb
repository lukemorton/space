require_relative 'ship_boarding_request'

module Space
  module Flight
    class ShipBoardingRequestGateway
      def initialize(ship_boarding_request_repository:)
        @ship_boarding_request_repository = ship_boarding_request_repository
      end

      def create(ship_id, person_id)
        ship_boarding_request_repository.create(ship_id: ship_id, requester_id: person_id)
      end

      def find(id)
        boarding_request = ship_boarding_request_repository.find_by(id: id)
        Space::Flight::ShipBoardingRequest.from_object(boarding_request) unless boarding_request.nil?
      end

      def cancel(id, person_id)
        ship_boarding_request_repository.where(id: id, requester_id: person_id).delete_all > 0
      end

      def delete(id)
        ship_boarding_request_repository.delete(id)
      end

      private

      attr_reader :ship_boarding_request_repository
    end
  end
end
