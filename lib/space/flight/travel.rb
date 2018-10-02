require_relative 'invalid_travel_error'
require_relative 'ship'
require_relative 'travel_validator'

module Space
  module Flight
    class Travel
      Response = Struct.new(:successful?, :errors)

      def initialize(location_gateway:, person_gateway:, ship_gateway:, travel_computer_factory:)
        @location_gateway = location_gateway
        @person_gateway = person_gateway
        @ship_gateway = ship_gateway
        @travel_computer_factory = travel_computer_factory
      end

      def travel(ship_id, to:)
        ship = ship_gateway.find(ship_id)
        location = location_gateway.find(to)
        fuel_calculator = travel_computer_factory.create_fuel_calculator(ship)

        travel_validator = TravelValidator.new(
          destination_location: location,
          fuel_calculator: fuel_calculator,
          ship: ship
        )

        raise InvalidTravelError.new(travel_validator.errors.full_messages) unless travel_validator.valid?

        ship_gateway.update(
          ship.id,
          dock_id: location.establishments.first.id,
          fuel: fuel_calculator.new_fuel_level,
          location_id: location.id
        )

        ship.crew.each do |member|
          person_gateway.update(member.id, location_id: location.id)
        end

        Response.new(true, {})
      end

      private

      attr_reader :location_gateway,
                  :person_gateway,
                  :ship_gateway,
                  :travel_computer_factory
    end
  end
end
