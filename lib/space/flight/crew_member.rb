require 'active_model'

module Space
  module Flight
    class CrewMember
      include ActiveModel::Model

      def self.from_object(object)
        new(
          id: object.id
        )
      end

      attr_accessor :id

      def to_param
        id.to_s
      end
    end
  end
end
