require 'active_model'
require_relative 'crew_member'
require_relative 'ship'

module Space
  module Flight
    class ShipGateway
      def initialize(ship_repository:)
        @ship_repository = ship_repository
      end

      def find(ship_id)
        ship = ship_repository.find(ship_id)
        Space::Flight::Ship.from_object(ship)
      end

      def update(ship_id, attrs)
        ship_repository.find(ship_id).update(attrs)
      end

      def remove_crew_member(ship_id, person_id)
        ship = ship_repository.find(ship_id)
        ship.crew.delete(person_id)
      end

      private

      attr_reader :ship_repository
    end
  end
end
