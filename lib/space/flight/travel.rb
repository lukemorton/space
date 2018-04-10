require 'active_model'

module Space
  module Flight
    class Travel
      Response = Struct.new(:successful?, :errors)

      def travel(person, to:)
        travel_validator = Validator.new(
          existing_station: person.location,
          destination_station: to
        )

        if travel_validator.valid?
          person.location = to
          Response.new(true, {})
        else
          Response.new(false, travel_validator.errors)
        end
      end

      private

      class Validator
        include ActiveModel::Model

        attr_accessor :existing_station, :destination_station

        validate :not_travelling_to_same_station

        private

        def not_travelling_to_same_station
          if existing_station == destination_station
            errors.add(:destination_station, 'Cannot travel to current location')
          end
        end
      end
    end
  end
end
