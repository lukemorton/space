require 'active_model'
require_relative 'could_not_create_person_error'

module Space
  module Folk
    class CreatePerson
      Response = Struct.new(:successful?, :errors)

      def initialize(person_gateway:)
        @person_gateway = person_gateway
      end

      def create(user_id, attrs)
        validator = Validator.new(attrs)

        if validator.valid?
          successful = person_gateway.create(
            name: attrs[:name],
            user_id: user_id
          )
          raise CouldNotCreatePersonError.new unless successful
          Response.new(true)
        else
          Response.new(false, validator.errors.full_messages)
        end
      end

      private

      attr_reader :person_gateway

      class Validator
        include ActiveModel::Model

        attr_accessor :name

        validates :name, presence: true
      end
    end
  end
end
