require_relative 'person'

module Space
  module Flight
    class PersonGateway
      def initialize(person_repository:)
        @person_repository = person_repository
      end

      def find(person_id)
        person = person_repository.find(person_id)
        Person.new(
          id: person.id,
          location_id: person.location_id
        )
      end

      def update(person_id, attrs)
        person_repository.find(person_id).update(attrs)
      end

      private

      attr_reader :person_repository
    end
  end
end
