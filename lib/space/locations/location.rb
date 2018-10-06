require 'active_model'

module Space
  module Locations
    class Location
      include ActiveModel::Model

      def self.from_object(object)
        new(
          id: object.id,
          coordinates: [
            object.coordinate_x,
            object.coordinate_y,
            object.coordinate_z,
          ],
          establishments: object.establishments.map { |establishment| Establishment.from_object(establishment) },
          name: object.name,
          slug: object.slug
        )
      end

      attr_accessor :id
      attr_accessor :coordinates
      attr_accessor :establishments
      attr_accessor :name
      attr_accessor :slug

      def to_param
        slug.to_s
      end

      class Establishment
        def self.from_object(object)
          Dock.from_object(object) unless object.nil?
        end
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
    end
  end
end
