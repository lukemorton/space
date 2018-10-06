module Space
  module Computers
    class EuclideanDistanceCalculator
      def name
        'Euclidean Distance Calculator by Space Inc.'
      end

      def description
        'Based on the maths of an ancient civilisation on Earth.'
      end

      def distance_between(location_a, location_b)
        x1, y1, z1 = location_a.coordinates
        x2, y2, z2 = location_b.coordinates

        Math.sqrt(((x1 - x2) ** 2) + ((y1 - y2) ** 2) + ((z1 - z2) ** 2))
      end
    end
  end
end
