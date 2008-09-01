require 'after_timestamps'

ActiveRecord::Base.send(:include, LostInCode::AfterTimestamps)