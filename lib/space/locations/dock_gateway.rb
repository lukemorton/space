require_relative 'dock'
require_relative 'location'

module Space
  module Locations
    class DockGateway
      def initialize(dock_repository:)
        @dock_repository = dock_repository
      end

      def find(id)
        dock = dock_repository.find_by(slug: id)
        return if dock.nil?
        Space::Locations::Dock.from_object(dock) do |object, attrs|
          attrs[:location] = Space::Locations::Location.from_object(object.location) do |object, attrs|
            attrs.delete(:establishments) # this stops recursion
          end
        end
      end

      private

      attr_reader :dock_repository
    end
  end
end
