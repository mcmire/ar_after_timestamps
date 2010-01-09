require 'helper'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => ":memory:"
)

ActiveRecord::Migration.suppress_messages do
  ActiveRecord::Schema.define do
    create_table :posts do |t|
      t.timestamps
      t.datetime :posted_at, :null => false
      t.string :formatted_created_at
      t.integer :timestamp
    end
  end
end

class Post < ActiveRecord::Base
  after_timestamps_on_create :set_posted_at_to_created_at
  after_timestamps_on_create {|post| post.formatted_created_at = post.created_at.strftime("%b/%Y-%d %D %H%M..%S") }
  after_timestamps_on_update :rollback_created_at
  after_timestamps_on_update {|post| post.timestamp = post.created_at.to_i }
  
  def set_posted_at_to_created_at
    self.posted_at = self.created_at
  end
  def rollback_created_at
    self.posted_at -= 2.days
  end
end

Protest.context("after_timestamps") do
  test "after_timestamps_on_create symbol is called on create" do
    Time.stubs(:now).returns(Time.local(2009))
    post = Post.new
    post.save!
    post.posted_at.should == Time.local(2009)
  end
  
  test "after_timestamps_on_create proc is called on create" do
    Time.stubs(:now).returns(Time.local(2009))
    post = Post.new
    post.save!
    post.formatted_created_at.should == "Jan/2009-01 01/01/09 0000..00"
  end
  
  test "after_timestamps_on_update symbol is called on update" do
    Time.stubs(:now).returns(Time.local(2009))
    post = Post.create!
    post.save!
    post.posted_at.should == Time.local(2008, 12, 30)
  end
  
  test "after_timestamp_on_update proc is called on update" do
    Time.stubs(:now).returns(Time.local(2009))
    post = Post.create!
    post.save!
    post.timestamp.should == 1230789600
  end
end