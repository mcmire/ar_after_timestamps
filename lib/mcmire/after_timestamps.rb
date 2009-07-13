module Mcmire
  module AfterTimestamps
    def self.included(klass)
      klass.class_eval do
        alias_method_chain :create_without_timestamps, :after_timestamps
        alias_method_chain :update_without_timestamps, :after_timestamps
        define_callbacks :after_timestamps, :after_timestamps_on_create, :after_timestamps_on_update
      end
    end
    
  private
    # Override create_without_timestamps to call the after_timestamps_on_create callback
    def create_without_timestamps_with_after_timestamps
      return false if callback(:after_timestamps) == false
      return false if callback(:after_timestamps_on_create) == false
      create_without_timestamps_without_after_timestamps
    end
  
    # Same thing, only for update_without_timestamps
    def update_without_timestamps_with_after_timestamps
      return false if callback(:after_timestamps) == false
      return false if callback(:after_timestamps_on_update) == false
      update_without_timestamps_without_after_timestamps
    end
  end
end
