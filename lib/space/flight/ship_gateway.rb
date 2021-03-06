require_relative 'ship'

module Space
  module Flight
    class ShipGateway
      def initialize(ship_repository:)
        @ship_repository = ship_repository
      end

      def find(ship_id)
        ship = ship_repository.find_by(id: ship_id)
        Space::Flight::Ship.from_object(ship) unless ship.nil?
      end

      def find_by_slug(ship_slug)
        ship = ship_repository.find_by(slug: ship_slug)
        Space::Flight::Ship.from_object(ship) unless ship.nil?
      end

      def update(ship_id, attrs)
        ship_repository.find(ship_id).update(attrs)
      end

      def add_crew_member(ship_id, person_id)
        ship = ship_repository.find(ship_id)
        ship.update!(crew_ids: ship.crew_ids << person_id)
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
