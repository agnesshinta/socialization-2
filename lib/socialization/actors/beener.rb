module ActiveRecord
  class Base
    def is_beener?
      false
    end
    alias beener? is_beener?
  end
end

module Socialization
  module Beener
    extend ActiveSupport::Concern

    included do
      after_destroy { Socialization.been_model.remove_beenables(self) }

      # Specifies if self can been {beenable} objects.
      #
      # @return [Boolean]
      def is_beener?
        true
      end
      alias beener? is_beener?

      # Create a new {been been} relationship.
      #
      # @param [beenable] beenable the object to be beened.
      # @return [Boolean]
      def been!(beenable)
        raise Socialization::ArgumentError, "#{beenable} is not beenable!"  unless beenable.respond_to?(:is_beenable?) && beenable.is_beenable?
        Socialization.been_model.been!(self, beenable)
      end

      # Delete a {been been} relationship.
      #
      # @param [beenable] beenable the object to unbeen.
      # @return [Boolean]
      def unbeen!(beenable)
        raise Socialization::ArgumentError, "#{beenable} is not beenable!" unless beenable.respond_to?(:is_beenable?) && beenable.is_beenable?
        Socialization.been_model.unbeen!(self, beenable)
      end

      # Toggles a {been been} relationship.
      #
      # @param [beenable] beenable the object to been/unbeen.
      # @return [Boolean]
      def toggle_been!(beenable)
        raise Socialization::ArgumentError, "#{beenable} is not beenable!" unless beenable.respond_to?(:is_beenable?) && beenable.is_beenable?
        if beens?(beenable)
          unbeen!(beenable)
          false
        else
          been!(beenable)
          true
        end
      end

      # Specifies if self beens a {beenable} object.
      #
      # @param [beenable] beenable the {beenable} object to test against.
      # @return [Boolean]
      def beens?(beenable)
        raise Socialization::ArgumentError, "#{beenable} is not beenable!" unless beenable.respond_to?(:is_beenable?) && beenable.is_beenable?
        Socialization.been_model.beens?(self,beenable)
      end

      # Returns all the beenables of a certain type that are beened by self
      #
      # @params [beenable] klass the type of {beenable} you want
      # @params [Hash] opts a hash of options
      # @return [Array<beenable, Numeric>] An array of beenable objects or IDs
      def beenables(klass, opts = {})
        Socialization.been_model.beenables(self, klass, opts)
      end
      alias :beenes :beenables

      # Returns a relation for all the beenables of a certain type that are beened by self
      #
      # @params [beenable] klass the type of {beenable} you want
      # @params [Hash] opts a hash of options
      # @return ActiveRecord::Relation
      def beenables_relation(klass, opts = {})
        Socialization.been_model.beenables_relation(self, klass, opts)
      end
      alias :beenes_relation :beenables_relation
    end
  end
end