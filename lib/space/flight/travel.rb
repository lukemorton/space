require 'active_model'
require_relative 'ship'

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
          destination_location: to,
          ship: ship
        )

        if travel_validator.valid?
          ship_gateway.update(
            ship.id,
            dock_id: location.establishments.first.id,
            fuel: new_fuel_level(ship),
            location_id: location.id
          )

          ship.crew.each do |member|
            person_gateway.update(member.id, location_id: location.id)
          end

          Response.new(true, {})
        else
          Response.new(false, travel_validator.errors)
        end
      end

      private

      attr_reader :location_gateway, :person_gateway, :ship_gateway

      def new_fuel_level(ship)
        ship.fuel - Space::Flight::Ship::FUEL_TO_TRAVEL
      end

      class Validator
        include ActiveModel::Model

        attr_accessor :ship, :destination_location

        validate :ship_has_enough_fuel
        validate :not_travelling_to_same_location

        private

        def ship_has_enough_fuel
          new_fuel = ship.fuel - Space::Flight::Ship::FUEL_TO_TRAVEL

          if new_fuel < 0
            errors.add(:fuel, 'Not enough fuel to travel')
          end
        end

        def not_travelling_to_same_location
          if ship.location == destination_location
            errors.add(:destination_location, 'Cannot travel to current location')
          end
        end
      end
    end
  end
end
