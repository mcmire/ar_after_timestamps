module Mcmire
  module AfterTimestamps
    module ClassMethods
      def after_timestamps_on_create(*callbacks, &block)
        callbacks << block if block_given?
        write_inheritable_array(:after_timestamps_on_create, callbacks)
      end
      def after_timestamps_on_update(*callbacks, &block)
        callbacks << block if block_given?
        write_inheritable_array(:after_timestamps_on_update, callbacks)
      end
    end
    
    def self.included(klass)
      klass.extend(ClassMethods)
    end
  
    def after_timestamps_on_create() end
    def after_timestamps_on_update() end
    
  private
    # Override create_with_timestamps to call the after_timestamps_on_create callback
    def create_with_timestamps
      return false if callback(:after_timestamps_on_create) == false
      super
    end
  
    # Same thing, only for update_with_timestamps
    def update_with_timestamps
      return false if callback(:after_timestamps_on_update) == false
      super
    end
  end
end
