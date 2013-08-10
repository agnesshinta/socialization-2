module Socialization
  module Stores
    module Mixins
      module Wish

      public
        def touch(what = nil)
          if what.nil?
            @touch || false
          else
            raise Socialization::ArgumentError unless [:all, :wisher, :wishable, false, nil].include?(what)
            @touch = what
          end
        end

        def after_wish(method)
          raise Socialization::ArgumentError unless method.is_a?(Symbol) || method.nil?
          @after_create_hook = method
        end

        def after_unwish(method)
          raise Socialization::ArgumentError unless method.is_a?(Symbol) || method.nil?
          @after_destroy_hook = method
        end

      protected
        def call_after_create_hooks(wisher, wishable)
          self.send(@after_create_hook, wishr, wishable) if @after_create_hook
          touch_dependents(wisher, wishable)
        end

        def call_after_destroy_hooks(wisher, wishable)
          self.send(@after_destroy_hook, wisher, wishable) if @after_destroy_hook
          touch_dependents(wisher, wishable)
        end

      end
    end
  end
end