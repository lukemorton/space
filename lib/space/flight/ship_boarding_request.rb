require 'active_model'
require_relative 'ship'

module Space
  module Flight
    class ShipBoardingRequest
      include ActiveModel::Model

      def self.from_object(object)
        new(
          id: object.id,
          ship: Ship.from_object(object.ship),
          requester: Requester.new(object.requester.id, object.requester.name)
        )
      end

      attr_accessor :id
      attr_accessor :ship
      attr_accessor :requester

      Requester = Struct.new(:id, :name)

      class Ship < Space::Flight::Ship; end
    end
  end
end
