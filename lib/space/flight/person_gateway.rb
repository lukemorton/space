module Space
  module Flight
    class PersonGateway
      def initialize(person_repository:)
        @person_repository = person_repository
      end

      def find(person_id)
        person_repository.find(person_id)
      end

      def update(person)
        person.save!
      end

      private

      attr_reader :person_repository
    end
  end
end
