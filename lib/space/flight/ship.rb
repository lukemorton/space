require 'active_model'

module Space
  module Flight
    class Ship
      include ActiveModel::Model

      attr_accessor :id
      attr_accessor :crew
      attr_accessor :dock
      attr_accessor :location

      def has_crew_member_id?(person_id)
        crew_ids = crew.map(&:id)
        crew_ids.include?(person_id)
      end

      def to_param
        id.to_s
      end
    end
  end
end
