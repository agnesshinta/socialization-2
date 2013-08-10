module ActiveRecord
  class Base
    def is_wishable?
      false
    end
    alias wishable? is_wishable?
  end
end

module Socialization
  module Wishable
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.wish_model.remove_wishers(self) }

      # Specifies if self can be wished.
      #
      # @return [Boolean]
      def is_wishable?
        true
      end
      alias wishable? is_wishable?

      # Specifies if self is wished by a {wisher} object.
      #
      # @return [Boolean]
      def wished_by?(wishr)
        raise Socialization::ArgumentError, "#{wisher} is not wisher!"  unless wisher.respond_to?(:is_wisher?) && wishr.is_wishr?
        Socialization.wish_model.wishs?(wisher, self)
      end

      # Returns an array of {wisher}s wishing self.
      #
      # @param [Class] klass the {wisher} class to be included. e.g. `User`
      # @return [Array<wisher, Numeric>] An array of wisher objects or IDs
      def wishers(klass, opts = {})
        Socialization.wish_model.wishers(self, klass, opts)
      end

      # Returns a scope of the {wisher}s liking self.
      #
      # @param [Class] klass the {wisher} class to be included in the scope. e.g. `User`
      # @return ActiveRecord::Relation
      def wishers_relation(klass, opts = {})
        Socialization.wish_model.wishers_relation(self, klass, opts)
      end

    end
  end
end