require 'active_model'
require_relative 'crew_member'
require_relative '../locations/establishment'
require_relative '../locations/location'

module Space
  module Flight
    class Ship
      include ActiveModel::Model

      def self.from_object(object)
        new(
          id: object.id,
          crew: object.crew.map { |member| Space::Flight::CrewMember.from_object(member) },
          dock: Space::Locations::Establishment.from_object(object.dock),
          location: Space::Locations::Location.from_object(object.location),
          name: object.name,
          slug: object.slug
        )
      end

      attr_accessor :id
      attr_accessor :crew
      attr_accessor :dock
      attr_accessor :location
      attr_accessor :name
      attr_accessor :slug

      def has_crew_member_id?(person_id)
        crew_ids = crew.map(&:id)
        crew_ids.include?(person_id)
      end

      def to_param
        slug.to_s
      end
    end
  end
end
