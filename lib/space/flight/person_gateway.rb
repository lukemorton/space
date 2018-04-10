module Space
  module Flight
    class PersonGateway
      def initialize(person_repository:)
        @person_repository = person_repository
      end

      def update(person)
        person_repository.find(person.id).update!(person.to_h)
      end

      private

      attr_reader :person_repository
    end
  end
end
