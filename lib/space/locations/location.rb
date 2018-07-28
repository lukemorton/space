require 'active_model'

module Space
  module Locations
    class Location
      include ActiveModel::Model

      def self.from_object(object)
        new(
          id: object.id,
          establishments: object.establishments,
          name: object.name
        )
      end

      attr_accessor :id
      attr_accessor :name
      attr_accessor :establishments

      def to_param
        id.to_s
      end
    end
  end
end
