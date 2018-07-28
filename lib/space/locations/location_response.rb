module Space
  module Locations
    LocationResponse = Struct.new(:id, :name, :establishments, :to_param)
  end
end
