require_relative 'dock'

module Space
  module Locations
    class DockGateway
      def initialize(dock_repository:)
        @dock_repository = dock_repository
      end

      def find_by_slug(slug)
        dock = dock_repository.find_by(slug: slug)
        return if dock.nil?
        Space::Locations::Dock.from_object(dock)
      end

      private

      attr_reader :dock_repository
    end
  end
end
