require 'active_model'
require_relative '../locations/location'

module Space
  module Flight
    class Person
      include ActiveModel::Model

      def self.from_object(object)
        new(
          id: object.id,
          location: Location.new(
            id: object.location.id
          )
        )
      end

      attr_accessor :id
      attr_accessor :location

      class Location
        include ActiveModel::Model

        attr_accessor :id
      end
    end
  end
end
