module Socialization
  module ActiveRecordStores
    class Wish < ActiveRecord::Base
      extend Socialization::Stores::Mixins::Base
      extend Socialization::Stores::Mixins::Wish
      extend Socialization::ActiveRecordStores::Mixins::Base

      belongs_to :wisher,    :polymorphic => true
      belongs_to :wishable, :polymorphic => true

      scope :wished_by, lambda { |wisher| where(
        :wisher_type    => wisher.class.table_name.classify,
        :wisher_id      => wisher.id)
      }

      scope :liking,   lambda { |wishable| where(
        :wishable_type => wishable.class.table_name.classify,
        :wishable_id   => wishable.id)
      }

      class << self
        def wish!(wisher, wishable)
          unless wishs?(wisher, wishable)
            self.create! do |wish|
              wish.wisher = wisher
              wish.wishable = wishable
            end
            call_after_create_hooks(wisher, wishable)
            true
          else
            false
          end
        end

        def unwish!(wisher, wishable)
          if wishs?(wisher, wishable)
            wish_for(wisher, wishable).destroy_all
            call_after_destroy_hooks(wisher, wishable)
            true
          else
            false
          end
        end

        def wishs?(wisher, wishable)
          !wish_for(wisher, wishable).empty?
        end

        # Returns an ActiveRecord::Relation of all the wishers of a certain type that are liking  wishable
        def wishers_relation(wishable, klass, opts = {})
          rel = klass.where(:id =>
            self.select(:wisher_id).
              where(:wisher_type => klass.table_name.classify).
              where(:wishable_type => wishable.class.to_s).
              where(:wishable_id => wishable.id)
          )

          if opts[:pluck]
            rel.pluck(opts[:pluck])
          else
            rel
          end
        end

        # Returns all the wishers of a certain type that are liking  wishable
        def wishers(wishable, klass, opts = {})
          rel = wishers_relation(wishable, klass, opts)
          if rel.is_a?(ActiveRecord::Relation)
            rel.all
          else
            rel
          end
        end

        # Returns an ActiveRecord::Relation of all the wishables of a certain type that are wished by wisher
        def wishables_relation(wisher, klass, opts = {})
          rel = klass.where(:id =>
            self.select(:wishable_id).
              where(:wishable_type => klass.table_name.classify).
              where(:wisher_type => wisher.class.to_s).
              where(:wisher_id => wisher.id)
          )

          if opts[:pluck]
            rel.pluck(opts[:pluck])
          else
            rel
          end
        end

        # Returns all the wishables of a certain type that are wished by wisher
        def wishables(wisher, klass, opts = {})
          rel = wishables_relation(wisher, klass, opts)
          if rel.is_a?(ActiveRecord::Relation)
            rel.all
          else
            rel
          end
        end

        # Remove all the wishers for wishable
        def remove_wishers(wishable)
          self.where(:wishable_type => wishable.class.name.classify).
               where(:wishable_id => wishable.id).destroy_all
        end

        # Remove all the wishables for wisher
        def remove_wishables(wisher)
          self.where(:wisher_type => wisher.class.name.classify).
               where(:wisher_id => wisher.id).destroy_all
        end

      private
        def wish_for(wisher, wishable)
          wished_by(wisher).liking( wishable)
        end
      end # class << self

    end
  end
end

