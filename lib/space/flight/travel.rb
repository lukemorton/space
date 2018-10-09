require_relative 'unknown_ship_error'
require_relative 'invalid_travel_error'
require_relative '../locations/unknown_location_error'
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

      def travel(ship_id, current_person:, to:)
        ship = ship_gateway.find(ship_id)
        raise UnknownShipError.new if ship.nil?

        location = location_gateway.find(to)
        raise Locations::UnknownLocationError.new if location.nil?

        fuel_calculator = travel_computer_factory.create_fuel_calculator(ship)

        travel_validator = TravelValidator.new(
          current_person_id: current_person,
          destination_location: location,
          fuel_calculator: fuel_calculator,
          ship: ship
        )

        if travel_validator.valid?
          ship_gateway.update(
            ship.id,
            dock_id: location.establishments.first.id,
            fuel: fuel_calculator.new_fuel_level(location),
            location_id: location.id
          )

          ship.crew.each do |member|
            person_gateway.update(member.id, location_id: location.id)
          end

          Response.new(true, [])
        else
          Response.new(false, travel_validator.errors.full_messages)
        end
      end

      private

      attr_reader :location_gateway,
                  :person_gateway,
                  :ship_gateway,
                  :travel_computer_factory
    end
  end
end
