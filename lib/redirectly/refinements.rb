module Redirectly
  module Refinements
    refine String do
      def comment?
        start_with? ';' or start_with? '#'
      end
    end
  end
end
