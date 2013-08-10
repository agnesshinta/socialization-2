module Socialization
  module ActiveRecordStores
    class Been < ActiveRecord::Base
      extend Socialization::Stores::Mixins::Base
      extend Socialization::Stores::Mixins::Been
      extend Socialization::ActiveRecordStores::Mixins::Base

      belongs_to :beener,    :polymorphic => true
      belongs_to :beenable, :polymorphic => true

      scope :beened_by, lambda { |beener| where(
        :beener_type    => beener.class.table_name.classify,
        :beener_id      => beener.id)
      }

      scope :liking,   lambda { |beenable| where(
        :beenable_type => beenable.class.table_name.classify,
        :beenable_id   => beenable.id)
      }

      class << self
        def been!(beener, beenable)
          unless beens?(beener, beenable)
            self.create! do |been|
              been.beener = beener
              been.beenable = beenable
            end
            call_after_create_hooks(beener, beenable)
            true
          else
            false
          end
        end

        def unbeen!(beener, beenable)
          if beens?(beener, beenable)
            been_for(beener, beenable).destroy_all
            call_after_destroy_hooks(beener, beenable)
            true
          else
            false
          end
        end

        def beens?(beener, beenable)
          !been_for(beener, beenable).empty?
        end

        # Returns an ActiveRecord::Relation of all the beeners of a certain type that are liking  beenable
        def beeners_relation(beenable, klass, opts = {})
          rel = klass.where(:id =>
            self.select(:beener_id).
              where(:beener_type => klass.table_name.classify).
              where(:beenable_type => beenable.class.to_s).
              where(:beenable_id => beenable.id)
          )

          if opts[:pluck]
            rel.pluck(opts[:pluck])
          else
            rel
          end
        end

        # Returns all the beeners of a certain type that are liking  beenable
        def beeners(beenable, klass, opts = {})
          rel = beeners_relation(beenable, klass, opts)
          if rel.is_a?(ActiveRecord::Relation)
            rel.all
          else
            rel
          end
        end

        # Returns an ActiveRecord::Relation of all the beenables of a certain type that are beened by beener
        def beenables_relation(beener, klass, opts = {})
          rel = klass.where(:id =>
            self.select(:beenable_id).
              where(:beenable_type => klass.table_name.classify).
              where(:beener_type => beener.class.to_s).
              where(:beener_id => beener.id)
          )

          if opts[:pluck]
            rel.pluck(opts[:pluck])
          else
            rel
          end
        end

        # Returns all the beenables of a certain type that are beened by beener
        def beenables(beener, klass, opts = {})
          rel = beenables_relation(beener, klass, opts)
          if rel.is_a?(ActiveRecord::Relation)
            rel.all
          else
            rel
          end
        end

        # Remove all the beeners for beenable
        def remove_beeners(beenable)
          self.where(:beenable_type => beenable.class.name.classify).
               where(:beenable_id => beenable.id).destroy_all
        end

        # Remove all the beenables for beener
        def remove_beenables(beener)
          self.where(:beener_type => beener.class.name.classify).
               where(:beener_id => beener.id).destroy_all
        end

      private
        def been_for(beener, beenable)
          beened_by(beener).liking( beenable)
        end
      end # class << self

    end
  end
end

