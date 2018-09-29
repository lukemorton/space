require 'active_model'
require_relative 'ship'

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

        travel_validator = travel_computer_factory.create_travel_validator(ship, location)

        if travel_validator.valid?
          fuel_calculator = travel_computer_factory.create_fuel_calculator(ship)

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
