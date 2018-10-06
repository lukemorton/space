module Space
  module Locations
    LocationResponse = Struct.new(:id, :coordinates, :name, :establishments, :to_param)
  end
end
