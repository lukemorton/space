require 'active_model'
require_relative 'could_not_create_person_error'

module Space
  module Folk
    class CreatePerson
      Response = Struct.new(:successful?, :validator)

      def initialize(location_gateway:, money_gateway:, person_gateway:)
        @location_gateway = location_gateway
        @money_gateway = money_gateway
        @person_gateway = person_gateway
      end

      def create(user_id, attrs)
        validator = Validator.new(attrs)

        if validator.valid?
          person = person_gateway.create(
            location_id: default_location_id,
            name: attrs[:name],
            user_id: user_id
          )
          raise CouldNotCreatePersonError.new if person.nil?
          money_gateway.initialize_bank(person)
          Response.new(true)
        else
          Response.new(false, validator)
        end
      end

      private

      attr_reader :location_gateway
      attr_reader :money_gateway
      attr_reader :person_gateway

      def default_location_id
        location_gateway.first.id
      end

      def transaction
        yield
      end

      class Validator
        include ActiveModel::Model

        attr_accessor :name

        validates :name, presence: true
      end
    end
  end
end
