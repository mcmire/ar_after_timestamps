require 'helper'

module CallbackChainInspector
  code = ""
  %w(
    create_or_update
    create_or_update_with_callbacks
    create_or_update_without_callbacks
    
    create
    create_with_callbacks
    create_without_callbacks
    create_with_timestamps
    create_without_timestamps
    
    update
    update_with_callbacks
    update_without_callbacks
    update_with_timestamps
    update_without_timestamps
    
    save
  ).each do |meth|
    code << <<-EOT
      def #{meth}(*args, &block)
        puts 'entering \##{meth}'
        ret = super
        puts 'leaving \##{meth}'
        ret
      end
    EOT
  end
  #puts "Code:"
  #puts code
  module_eval(code, __FILE__, __LINE__)
end

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => ":memory:"
)

ActiveRecord::Schema.define do
  create_table :posts do |t|
    t.timestamps
    t.datetime :posted_at, :null => false
    t.string :formatted_created_at
    t.integer :timestamp
  end
end

class Post < ActiveRecord::Base
  #include CallbackChainInspector
  
  after_timestamps_on_create :set_posted_at_to_created_at
  after_timestamps_on_create {|post| post.formatted_created_at = post.created_at.strftime("%b/%Y-%d %D %H%M..%S") }
  after_timestamps_on_update :rollback_created_at
  after_timestamps_on_update {|post| post.timestamp = post.created_at.to_i }
  #before_create :set_posted_at_to_created_at
  
  def set_posted_at_to_created_at
    #puts "Created at: #{self.created_at}"
    self.posted_at = self.created_at
  end
  def rollback_created_at
    self.posted_at -= 2.days
  end
  
  #def before_create
  #  puts '#before_create called'
  #end
  #def after_create
  #  puts '#after_create called'
  #end
  #def before_save
  #  puts '#before_save called'
  #end
  #def after_save
  #  puts '#after_save called'
  #end
end
#require 'pp'
#pp "Post.ancestors" => Post.ancestors

class AfterTimestampsTest < Test::Unit::TestCase
  test "after_timestamps_on_create symbol is called on create" do
    stub(Time).now { Time.local(2009) }
    post = Post.new
    post.save!
    post.posted_at.should == Time.local(2009)
  end
  
  test "after_timestamps_on_create proc is called on create" do
    stub(Time).now { Time.local(2009) }
    post = Post.new
    post.save!
    post.formatted_created_at.should == "Jan/2009-01 01/01/09 0000..00"
  end
  
  test "after_timestamps_on_update symbol is called on update" do
    stub(Time).now { Time.local(2009) }
    post = Post.create!
    post.save!
    post.posted_at.should == Time.local(2008, 12, 30)
  end
  
  test "after_timestamp_on_update proc is called on update" do
    stub(Time).now { Time.local(2009) }
    post = Post.create!
    post.save!
    post.timestamp.should == 1230789600
  end
end
