## after_timestamps

### Summary

Plugin for Ruby on Rails that gives you a way to add a callback to the ActiveRecord
callback chain that will be executed right after the record's timestamp columns are
set, but before the record is actually saved to the database. This is useful if you
want to modify the timestamp values.

### Example

Migration:

  class AddFoo < ActiveRecord::Migration
    def self.up
      create_table :foo {|t| t.timestamps }
    end
    def self.down
      drop_table :foo
    end
  end

Model:
  
  class Foo < ActiveRecord::Base
    after_timestamps_on_create :roll_back_created_at_by_two_hours
    after_timestamps_on_update :roll_back_updated_at_by_two_hours
    
  private
    def roll_back_created_at_by_two_hours
      self.created_at -= 2.hours
    end
    
    def roll_back_updated_at_by_two_hours
      self.updated_at -= 2.hours
    end
  end
  
Now if you say

  Foo.create!
  
`created_at` and `updated_at` will be set, but 2 hours will be subtracted from them
before they're put into the database.

### License

(c) 2008 Elliot Winkler. Released under the MIT license.