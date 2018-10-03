require 'active_model'
require_relative '../locations/location'

module Space
  module Folk
    class Person
      include ActiveModel::Model

      def self.from_object(object)
        new(
          id: object.id,
          location: Location.new(
            id: object.location.id,
            slug: object.location.slug
          ),
          name: object.name,
          ship: Ship.from_object(object.ship)
        )
      end

      attr_accessor :id
      attr_accessor :location
      attr_accessor :name
      attr_accessor :ship

      def aboard_ship?
        !ship.nil?
      end

      private

      attr_reader :ship_id

      class Location
        include ActiveModel::Model

        attr_accessor :id
        attr_accessor :slug

        def to_param
          slug
        end
      end

      class Ship
        include ActiveModel::Model

        def self.from_object(object)
          return if object.nil?
          new(
            id: object.id,
            slug: object.slug
          )
        end

        attr_accessor :id
        attr_accessor :slug

        def to_param
          slug
        end
      end
    end
  end
end
