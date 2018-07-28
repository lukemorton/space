require 'active_model'

module Space
  module Locations
    class Location
      include ActiveModel::Model

      def self.from_object(object)
        attrs = {
          id: object.id,
          establishments: object.establishments&.map { |establishment| Space::Locations::Establishment.from_object(establishment) },
          name: object.name
        }
        yield(object, attrs) if block_given?
        new(attrs)
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
