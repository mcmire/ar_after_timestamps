require 'active_record'

require 'mcmire/after_timestamps'

ActiveRecord::Base.class_eval do
  include Mcmire::AfterTimestamps
end
