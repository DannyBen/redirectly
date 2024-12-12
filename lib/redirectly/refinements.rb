module Redirectly
  module Refinements
    refine String do
      def ignored?
        empty? || comment? || section?
      end

      def comment?
        start_with?(';') || start_with?('#')
      end

      def section?
        match?(/^\[.+\]$/)
      end
    end
  end
end
