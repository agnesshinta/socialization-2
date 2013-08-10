module ActiveRecord
  class Base
    def is_wisher?
      false
    end
    alias wisher? is_wisher?
  end
end

module Socialization
  module Wisher
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.wish_model.remove_wishables(self) }

      # Specifies if self can wish {wishable} objects.
      #
      # @return [Boolean]
      def is_wisher?
        true
      end
      alias wisher? is_wisher?

      # Create a new {wish wish} relationship.
      #
      # @param [wishable] wishable the object to be wished.
      # @return [Boolean]
      def wish!(wishable)
        raise Socialization::ArgumentError, "#{wishable} is not wishable!"  unless wishable.respond_to?(:is_wishable?) && wishable.is_wishable?
        Socialization.wish_model.wish!(self, wishable)
      end

      # Delete a {wish wish} relationship.
      #
      # @param [wishable] wishable the object to unwish.
      # @return [Boolean]
      def unwish!(wishable)
        raise Socialization::ArgumentError, "#{wishable} is not wishable!" unless wishable.respond_to?(:is_wishable?) && wishable.is_wishable?
        Socialization.wish_model.unwish!(self, wishable)
      end

      # Toggles a {wish wish} relationship.
      #
      # @param [wishable] wishable the object to wish/unwish.
      # @return [Boolean]
      def toggle_wish!(wishable)
        raise Socialization::ArgumentError, "#{wishable} is not wishable!" unless wishable.respond_to?(:is_wishable?) && wishable.is_wishable?
        if wishes?(wishable)
          unwish!(wishable)
          false
        else
          wish!(wishable)
          true
        end
      end

      # Specifies if self wishs a {wishable} object.
      #
      # @param [wishable] wishable the {wishable} object to test against.
      # @return [Boolean]
      def wishes?(wishable)
        raise Socialization::ArgumentError, "#{wishable} is not wishable!" unless wishable.respond_to?(:is_wishable?) && wishable.is_wishable?
        Socialization.wish_model.wishs?(self,wishable)
      end

      # Returns all the wishables of a certain type that are wished by self
      #
      # @params [wishable] klass the type of {wishable} you want
      # @params [Hash] opts a hash of options
      # @return [Array<wishable, Numeric>] An array of wishable objects or IDs
      def wishables(klass, opts = {})
        Socialization.wish_model.wishables(self, klass, opts)
      end
      alias :wishes :wishables

      # Returns a relation for all the wishables of a certain type that are wished by self
      #
      # @params [wishable] klass the type of {wishable} you want
      # @params [Hash] opts a hash of options
      # @return ActiveRecord::Relation
      def wishables_relation(klass, opts = {})
        Socialization.wish_model.wishables_relation(self, klass, opts)
      end
      alias :wishes_relation :wishables_relation
    end
  end
end