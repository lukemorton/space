require_relative 'person'

module Space
  module Folk
    class PersonGateway
      def initialize(person_repository:)
        @person_repository = person_repository
      end

      def find(person_id)
        person = person_repository.find_by(id: person_id)
        Space::Folk::Person.from_object(person) unless person.nil?
      end

      def create(attrs)
        person = person_repository.create(attrs)
        Space::Folk::Person.from_object(person) unless person.nil?
      end

      def update(person_id, attrs)
        person_repository.find(person_id).update(attrs)
      end

      private

      attr_reader :person_repository
    end
  end
end
