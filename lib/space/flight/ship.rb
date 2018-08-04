require 'active_model'
require_relative '../locations/establishment'
require_relative '../locations/location'

module Space
  module Flight
    class Ship
      include ActiveModel::Model

      FUEL_MAX = 100
      FUEL_TO_TRAVEL = 10

      def self.from_object(object)
        new(
          id: object.id,
          crew: object.crew.map { |member| CrewMember.from_object(member) },
          dock: Dock.from_object(object.dock),
          fuel: object.fuel,
          location: Location.from_object(object.location),
          name: object.name,
          slug: object.slug
        )
      end

      attr_accessor :id
      attr_accessor :crew
      attr_accessor :dock
      attr_accessor :fuel
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

      class CrewMember
        include ActiveModel::Model

        def self.from_object(object)
          new(
            id: object.id,
            name: object.name
          )
        end

        attr_accessor :id
        attr_accessor :name
      end

      class Dock
        include ActiveModel::Model

        def self.from_object(object)
          return if object.nil?
          new(
            id: object.id,
            name: object.name,
            slug: object.slug
          )
        end

        attr_accessor :id
        attr_accessor :name
        attr_accessor :slug

        def to_param
          slug.to_s
        end
      end

      class Location
        include ActiveModel::Model

        def self.from_object(object)
          return if object.nil?
          new(
            id: object.id,
            name: object.name,
            slug: object.slug
          )
        end

        attr_accessor :id
        attr_accessor :name
        attr_accessor :slug

        def to_param
          slug.to_s
        end
      end
    end
  end
end
