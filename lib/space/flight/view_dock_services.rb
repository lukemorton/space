require 'money'
require_relative 'list_destinations'
require_relative 'person_not_in_crew_error'
require_relative 'ship'
require_relative 'unknown_ship_error'

module Space
  module Flight
    class ViewDockServices
      Response = Struct.new(
        :refuel_service
      )
      Response::RefuelService = Struct.new(:options)
      Response::RefuelService::Option = Struct.new(:type, :cost)

      def initialize(person_gateway:, ship_gateway:)
        @person_gateway = person_gateway
        @ship_gateway = ship_gateway
      end

      def view(ship_slug, person_id)
        ship = ship(ship_slug)
        raise UnknownShipError.new if ship.nil?

        person = person(person_id)
        raise PersonNotInCrewError.new unless ship.has_crew_member_id?(person.id)

        Response.new(
          build_refuel_service,
        )
      end

      private

      attr_reader :person_gateway,
                  :ship_gateway

      def ship(ship_slug)
        ship_gateway.find_by_slug(ship_slug)
      end

      def person(person_id)
        person_gateway.find(person_id)
      end

      def build_refuel_service
        Response::RefuelService.new([
          Response::RefuelService::Option.new(:full_tank, Money.new(300_00)),
          Response::RefuelService::Option.new(:half_tank, Money.new(150_00))
        ])
      end
    end
  end
end
