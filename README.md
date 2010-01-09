# ar_after_timestamps

## Summary

A little gem that gives you a way to add a callback to the ActiveRecord callback chain that will be executed right after the record's timestamp columns are set, but before the record is actually saved to the database. This is useful if you want to do something with the timestamps, such as defaulting another time column to created_at, or rolling back a timestamp by a certain amount.

## Example

Let's say you have a migration like this:

    class AddFoo < ActiveRecord::Migration
      def self.up
        create_table :foo {|t| t.timestamps }
      end
      def self.down
        drop_table :foo
      end
    end

And a model like this:
  
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
  
`created_at` and `updated_at` will be set, but 2 hours will be subtracted from them before they're put into the database.

## Installation

1. Run `gem install ar_after_timestamps` (probably as root)
2. Add `config.gem 'ar_after_timestamps'` to environment.rb
3. Optionally run `rake gems:build`

## Support

If you find any bugs with this plugin, feel free to:

* file a bug report in the [Issues area on Github](http://github.com/mcmire/ar_after_timestamps/issues)
* fork the [project on Github](http://github.com/mcmire/ar_after_timestamps) and send me a pull request
* email me (*firstname* dot *lastname* at gmail dot com)

## Author/License

(c) 2008-2010 Elliot Winkler. See LICENSE for details.