require 'active_model'

module Space
  module Locations
    class Establishment
      def self.from_object(object)
        return if object.nil?
        Space::Locations::Dock.new(
          id: object.id
        )
      end
    end
  end
end
