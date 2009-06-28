require 'mcmire/after_timestamps'

ActiveRecord::Base.send(:include, Mcmire::AfterTimestamps)
