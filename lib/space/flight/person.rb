require 'active_model'

module Space
  module Flight
    class Person
      include ActiveModel::Model

      attr_accessor :id
      attr_accessor :location

      def to_param
        id.to_s
      end
    end
  end
end
