require 'active_model'
require_relative '../locations/location'

module Space
  module Flight
    class Person
      include ActiveModel::Model

      def self.from_object(object)
        new(
          id: object.id,
          location: Space::Locations::Location.from_object(object.location)
        )
      end

      attr_accessor :id
      attr_accessor :location

      def to_param
        id.to_s
      end
    end
  end
end
