module Socialization
  module Stores
    module Mixins
      module Been

      public
        def touch(what = nil)
          if what.nil?
            @touch || false
          else
            raise Socialization::ArgumentError unless [:all, :beener, :beenable, false, nil].include?(what)
            @touch = what
          end
        end

        def after_been(method)
          raise Socialization::ArgumentError unless method.is_a?(Symbol) || method.nil?
          @after_create_hook = method
        end

        def after_unbeen(method)
          raise Socialization::ArgumentError unless method.is_a?(Symbol) || method.nil?
          @after_destroy_hook = method
        end

      protected
        def call_after_create_hooks(beener, beenable)
          self.send(@after_create_hook, beener, beenable) if @after_create_hook
          touch_dependents(beener, beenable)
        end

        def call_after_destroy_hooks(beener, beenable)
          self.send(@after_destroy_hook, beener, beenable) if @after_destroy_hook
          touch_dependents(beener, beenable)
        end

      end
    end
  end
end