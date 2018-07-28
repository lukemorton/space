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
        Ship.new(
          id: ship.id,
          crew_ids: ship.crew_ids,
          crew: ship.crew.map { |member| CrewMember.new(id: member.id) },
          dock: ship.dock,
          location: Space::Locations::Location.new(
            id: ship.location.id,
            establishments: ship.location.establishments,
            name: ship.location.name
          )
        )
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
