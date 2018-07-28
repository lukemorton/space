require_relative 'dock'

module Space
  module Locations
    class DockGateway
      def initialize(dock_repository:)
        @dock_repository = dock_repository
      end

      def find(id)
        dock = dock_repository.find(id)
        Dock.from_object(dock)
      end

      private

      attr_reader :dock_repository
    end
  end
end
