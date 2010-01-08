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
  #   # The first thing I want to talk about is mixins and Ruby's inheritance chain.
  # Let's take this code:
  #
  #   module M
  #     def foo; puts "yay!"; end
  #   end
  #
  #   class A
  #     include M
  #   end
  #
  # You might think the `include` copies `M#foo` into A. It is true that
  # we can now say `A#foo` and this will call the `foo` method in M, but nothing
  # is copied. In fact, it's much simpler: M is added to A's inheritance chain.
  # If you were to say `A.ancestors`, you'd get something like:
  #
  #   [A, M, Object, Kernel]
  #
  # What this means is that in order to find an instance method of A, Ruby
  # first looks in Klass, then Mod, then Object, and finally Kernel.
  #
  # Let's take that same setup and modify it just a bit:
  #
  #   module M
  #     def foo; puts "yay!"; end
  #   end
  #
  #   class A
  #     include M
  #     def 
  #   end
  #
  #   class B < A
  #   end
  #
  # So, `B.new.foo` now prints out "yay!". That's great, but let's say we come
  # along later and want to mixin something else in that 
  #
  # If you're used to thinking `include` copies methods, you might think, "Ok,
  # N#foo gets copied into A with the include, A#foo overrides that, B inherits
  # from A so it inherits A#foo, and then that's overridden when M is included."
  # What
  #
  #
  
   
    def self.included(klass)
      klass.class_eval do
        alias_method_chain :create_without_timestamps, :after_timestamps
        alias_method_chain :update_without_timestamps, :after_timestamps
        define_callbacks :after_timestamps_on_create, :after_timestamps_on_update#, :after_timestamps
      end
    end
    
    #def after_timestamps() end
    def after_timestamps_on_create() end
    def after_timestamps_on_update() end
    
  private
    # Override create_with_timestamps to call the after_timestamps_on_create callback
    def create_without_timestamps_with_after_timestamps
      #return false if callback(:after_timestamps) == false
      return false if callback(:after_timestamps_on_create) == false
      create_without_timestamps_without_after_timestamps
    end
  
    # Same thing, only for update_with_timestamps
    def update_without_timestamps_with_after_timestamps
      #return false if callback(:after_timestamps) == false
      return false if callback(:after_timestamps_on_update) == false
      update_without_timestamps_without_after_timestamps
    end
    
    #def self.included(base)
    #  base.extend(ClassMethods)
    #end
    #
    #module ClassMethods
    #  def inherited(subclass)
    #    subclass.define_callbacks :after_timestamps_on_create, :after_timestamps_on_update
    #    subclass.class_eval { include InstanceMethods }
    #    super
    #  end
    #end
    #
    #module InstanceMethods  
    #  def after_timestamps_on_create() end
    #  def after_timestamps_on_update() end
    #
    #private
    #  # Override create_without_timestamps to call the after_timestamps_on_create callback
    #  def create_without_timestamps
    #    return false if callback(:after_timestamps_on_create) == false
    #    super
    #  end
    #
    #  # Same thing, only for update_without_timestamps
    #  def update_without_timestamps
    #    return false if callback(:after_timestamps_on_update) == false
    #    super
    #  end
    #end
  end
end
