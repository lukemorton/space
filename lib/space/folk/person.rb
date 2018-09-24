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
            id: object.location.id
          ),
          ship_id: object.ship_id
        )
      end

      attr_accessor :id
      attr_accessor :location
      attr_writer :ship_id

      def aboard_ship?
        !ship_id.nil?
      end

      private

      attr_reader :ship_id

      class Location
        include ActiveModel::Model

        attr_accessor :id
      end
    end
  end
end
