require 'active_model'
require_relative '../flight/ship'

module Space
  module Locations
    class Dock
      class LocationNotLoadedError < RuntimeError; end

      include ActiveModel::Model

      def self.from_object(object)
        return if object.nil?
        new(
          id: object.id,
          location: Location.from_object(object.location),
          name: object.name,
          ships: object.ships.map { |ship| Ship.from_object(ship) },
          slug: object.slug
        )
      end

      attr_accessor :id
      attr_accessor :location
      attr_accessor :name
      attr_accessor :ships
      attr_accessor :slug

      def to_param
        slug.to_s
      end

      class Location
        include ActiveModel::Model

        def self.from_object(object)
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
          slug
        end
      end

      class Ship
        include ActiveModel::Model

        def self.from_object(object)
          new(
            id: object.id,
            crew: object.crew.map { |member| CrewMember.from_object(member) },
            name: object.name,
            slug: object.slug
          )
        end

        attr_accessor :id
        attr_accessor :crew
        attr_accessor :name
        attr_accessor :slug

        def has_crew_member_id?(person_id)
          crew_ids = crew.map(&:id)
          crew_ids.include?(person_id)
        end

        def to_param
          slug
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
      end
    end
  end
end
