module Mcmire
  # You probably know that every time a record is created, its created_at field
  # is automatically filled in. And every time a record is updated, its updated_at
  # field is filled in. This "magic" happens because of ActiveRecord's
  # Timestamp module, which is mixed in when ActiveRecord::Base is require()'d.
  #
  # Unfortunately, if you want to adjust these times for any reason before the
  # record is actually saved to the database, there isn't a built-in way to do
  # this. So, what we have to end up doing is inserting another method into the
  # ActiveRecord callback chain. However, doing so can be kind of tricky if you
  # don't know what's going on behind the scenes. This is because ActiveRecord
  # starts out with a set of standard methods in AR::Base and then several modules
  # are mixed in that override some of those methods.
  #
  # The methods that we are concerned about are the ones that are called when
  # you say `some_record.save`:
  #
  #                                    save
  #                                     |
  #                              create_or_update
  #                               /           \
  #                           create         update
  #
  # The modules which are mixed into AR::Base that we are concerned about are
  # AR::Timestamp and AR::Callbacks. Both use alias_method_chain to override
  # the methods, so you will see that below. Anyway, when AR::Timestamp is mixed
  # in this is what the call tree like:
  #
  #                                    save
  #                                     |
  #                              create_or_update
  #                      ......./                \.......
  #                     /                                \
  #         create(_with_timestamps)         update(_with_timestamps)
  #                    |                                 | 
  #        create_without_timestamps         update_without_timestamps
  #
  # (The parentheses are there to indicate the effects of alias_method_chain.)
  #
  # And when AR::Callbacks is mixed in, the tree changes again:
  #
  #                                    save
  #                                     |
  #                      create_or_update(_with_callbacks)
  #                                     |
  #                               before_save
  #                                     |
  #                     create_or_update_without_callbacks
  #                 ............/   ^   |   ^    \..........
  #                v                |   |   |               v
  #     create(_with_callbacks)     |   |   |     update(_with_callbacks)
  #               |                 |   |   |                |
  #         before_create           |   |   |          before_update
  #               |                 |   |   |                |
  #    create_without_callbacks     |   |   |    update_without_callbacks
  #               |                 |   |   |                |
  #    create_without_timestamps   /    |    \   update_without_timestamps
  #               |               /     |     \              |
  #          after_create .......´      |      '....... after_update
  #                                     |
  #                                     v
  #                                 after_save 
  #
  # As you can see, when the before_save callback is fired, the timestamps
  # haven't been set yet. Even at before_create/before_update, the timestamps
  # still haven't been set yet. Of course, by the time after_create/after_update,
  # it's too late to adjust the timestamps, since the record has already been
  # saved.
  #
  # That's why we need to insert a custom callback in the chain. We do this by
  # simply alias_method_chain()'ing create_without_timestamps and
  # update_without_timestamps to do what we want.
  #
  module AfterTimestamps
    VERSION = "0.1.0"
    
    def self.included(klass)
      klass.class_eval do
        alias_method_chain :create_without_timestamps, :after_timestamps
        alias_method_chain :update_without_timestamps, :after_timestamps
        define_callbacks :after_timestamps_on_create, :after_timestamps_on_update
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
