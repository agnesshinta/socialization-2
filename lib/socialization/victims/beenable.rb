module ActiveRecord
  class Base
    def is_beenable?
      false
    end
    alias beenable? is_beenable?
  end
end

module Socialization
  module Beenable
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.been_model.remove_beenrs(self) }

      # Specifies if self can be beened.
      #
      # @return [Boolean]
      def is_beenable?
        true
      end
      alias beenable? is_beenable?

      # Specifies if self is beened by a {beener} object.
      #
      # @return [Boolean]
      def beened_by?(beener)
        raise Socialization::ArgumentError, "#{beener} is not beener!"  unless beener.respond_to?(:is_beener?) && beenr.is_beenr?
        Socialization.been_model.beens?(beener, self)
      end

      # Returns an array of {beener}s beening self.
      #
      # @param [Class] klass the {beener} class to be included. e.g. `User`
      # @return [Array<beener, Numeric>] An array of beener objects or IDs
      def beeners(klass, opts = {})
        Socialization.been_model.beeners(self, klass, opts)
      end

      # Returns a scope of the {beener}s liking self.
      #
      # @param [Class] klass the {beener} class to be included in the scope. e.g. `User`
      # @return ActiveRecord::Relation
      def beeners_relation(klass, opts = {})
        Socialization.been_model.beeners_relation(self, klass, opts)
      end

    end
  end
end