module Space
  module Folk
    class ViewHud
      Response = Struct.new(:id, :location, :name, :ship)

      def initialize(money_gateway:, person_gateway:)
        @money_gateway = money_gateway
        @person_gateway = person_gateway
      end

      def view(person_id)
        person = person_gateway.find(person_id)

        Response.new(
          person.id,
          person.location,
          person.name,
          person.ship
        )
      end

      private

      attr_reader :money_gateway
      attr_reader :person_gateway
    end
  end
end
