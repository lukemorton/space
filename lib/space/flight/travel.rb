require 'active_model'

module Space
  module Flight
    class Travel
      Response = Struct.new(:successful?, :errors)

      def initialize(location_gateway:, person_gateway:, ship_gateway:)
        @location_gateway = location_gateway
        @person_gateway = person_gateway
        @ship_gateway = ship_gateway
      end

      def travel(ship_id, to:)
        ship = ship_gateway.find(ship_id)
        location = location_gateway.find(to)

        travel_validator = Validator.new(
          existing_location: ship.location,
          destination_location: to
        )

        if travel_validator.valid?
          ship_gateway.update(
            ship.id,
            dock: location.establishments.first,
            location: location
          )

          ship.crew.each do |member|
            person_gateway.update(member.id, location: location)
          end

          Response.new(true, {})
        else
          Response.new(false, travel_validator.errors)
        end
      end

      private

      attr_reader :location_gateway, :person_gateway, :ship_gateway

      class Validator
        include ActiveModel::Model

        attr_accessor :existing_location, :destination_location

        validate :not_travelling_to_same_location

        private

        def not_travelling_to_same_location
          if existing_location == destination_location
            errors.add(:destination_location, 'Cannot travel to current location')
          end
        end
      end
    end
  end
end
