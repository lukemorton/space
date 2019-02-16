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

      class Ship
        include ActiveModel::Model

        def self.from_object(object)
          new(
            id: object.id,
            crew: object.crew
          )
        end

        attr_accessor :id
        attr_accessor :crew

        def has_crew_member_id?(person_id)
          crew_ids = crew.map(&:id)
          crew_ids.include?(person_id)
        end
      end
    end
  end
end
