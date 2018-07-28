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
          location: Space::Locations::Location.new(
            id: person.location.id,
            establishments: person.location.establishments,
            name: person.location.name
          )
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
