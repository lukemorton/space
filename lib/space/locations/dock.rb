require 'active_model'

module Space
  module Locations
    class Dock
      include ActiveModel::Model

      def self.from_object(object)
        return if object.nil?
        new(
          id: object.id
        )
      end

      attr_accessor :id

      def name
        'Dock'
      end

      def to_param
        id.to_s
      end
    end
  end
end
