module Space
  module Flight
    class ShipGateway
      def initialize(ship_repository:)
        @ship_repository = ship_repository
      end

      def find(ship_id)
        ship_repository.find_by(id: ship_id)
      end

      def update(ship)
        ship.save!
      end

      private

      attr_reader :ship_repository
    end
  end
end
