module McMire
  module AfterTimestamps
    def self.included(klass)
      klass.class_eval do
        alias_method_chain :create_without_timestamps, :after_timestamps
        alias_method_chain :update_without_timestamps, :after_timestamps
      
        def self.after_timestamps_on_create(*callbacks, &block)
          callbacks << block if block_given?
          write_inheritable_array(:after_timestamps_on_create, callbacks)
        end
        def self.after_timestamps_on_update(*callbacks, &block)
          callbacks << block if block_given?
          write_inheritable_array(:after_timestamps_on_update, callbacks)
        end 
      end
    end
  
    def after_timestamps_on_create() end
    def after_timestamps_on_update() end
    
  private
    # Override create_with_timestamps to call the after_timestamps_on_create callback
    def create_without_timestamps_with_after_timestamps
      return false if callback(:after_timestamps_on_create) == false
      create_without_timestamps_without_after_timestamps
    end
  
    # Same thing, only for update_with_timestamps
    def update_without_timestamps_with_after_timestamps
      return false if callback(:after_timestamps_on_update) == false
      update_without_timestamps_without_after_timestamps
    end
  end
end