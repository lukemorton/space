module Space
  module Flight
    class CancelRequestToBoard
      Response = Struct.new(:successful?)

      def initialize(ship_boarding_request_gateway:)
        @ship_boarding_request_gateway = ship_boarding_request_gateway
      end

      def cancel(ship_boarding_request_id, person_id)
        ship_boarding_request_gateway.cancel(ship_boarding_request_id, person_id)
        Response.new(true)
      end

      private

      attr_reader :ship_boarding_request_gateway
    end
  end
end
