require 'active_record'

require 'mcmire/ar_after_timestamps'

ActiveRecord::Base.class_eval do
  include Mcmire::ARAfterTimestamps
end
