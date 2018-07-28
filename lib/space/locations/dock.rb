require 'active_model'
require_relative '../flight/ship'

module Space
  module Locations
    class Dock
      class LocationNotLoadedError < RuntimeError; end

      include ActiveModel::Model

      def self.from_object(object)
        return if object.nil?
        attrs = {
          id: object.id,
          ships: object.ships.map { |ship| Space::Flight::Ship.from_object(ship) }
        }
        yield(object, attrs) if block_given?
        new(attrs)
      end

      attr_accessor :id
      attr_accessor :location
      attr_accessor :ships

      def name
        'Dock'
      end

      def location
        @location or raise LocationNotLoadedError.new
      end

      def to_param
        id.to_s
      end
    end
  end
end
