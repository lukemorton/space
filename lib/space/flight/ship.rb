require 'active_model'

module Space
  module Flight
    class Ship
      include ActiveModel::Model

      def self.from_object(object)
        new(
          id: object.id,
          crew: object.crew.map { |member| Space::Flight::CrewMember.from_object(member) },
          dock: Space::Locations::Establishment.from_object(object.dock),
          location: Space::Locations::Location.from_object(object.location)
        )
      end

      attr_accessor :id
      attr_accessor :crew
      attr_accessor :dock
      attr_accessor :location

      def has_crew_member_id?(person_id)
        crew_ids = crew.map(&:id)
        crew_ids.include?(person_id)
      end

      def to_param
        id.to_s
      end
    end
  end
end
