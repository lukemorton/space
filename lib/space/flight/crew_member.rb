require 'active_model'

module Space
  module Flight
    class CrewMember
      include ActiveModel::Model

      def self.from_object(object)
        new(
          id: object.id,
          name: object.name
        )
      end

      attr_accessor :id
      attr_accessor :name

      def to_param
        id.to_s
      end
    end
  end
end
