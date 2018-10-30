require_relative 'person_not_in_crew_error'
require_relative 'unknown_ship_error'

module Space
  module Flight
    class ViewCrewOverview
      Response = Struct.new(
        :boarding_requests,
        :crew
      )
      Response::BoardingRequest = Struct.new(:requester)
      Response::BoardingRequest::Requester = Struct.new(:name)
      Response::CrewMember = Struct.new(:name)

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
          build_boarding_requests(ship),
          build_crew(ship)
        )
      end

      private

      attr_reader :list_destinations_use_case,
                  :person_gateway,
                  :ship_gateway,
                  :travel_computer_factory

      def ship(ship_slug)
        ship_gateway.find_by_slug(ship_slug)
      end

      def person(person_id)
        person_gateway.find(person_id)
      end

      def person_in_crew?(person_id, crew)
        crew_ids = crew.map(&:id)
        crew_ids.include?(person_id)
      end

      def build_boarding_requests(ship)
        ship.boarding_requests do |boarding_request|
          Response::BoardingRequest.new(
            Response::BoardingRequest::Requester.new(boarding_request.requester.name)
          )
        end
      end

      def build_crew(ship)
        ship.crew { |crew_member| Response::CrewMember.new(crew_member.name) }
      end
    end
  end
end
