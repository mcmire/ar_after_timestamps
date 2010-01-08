require 'rubygems'

require 'test/unit'
gem 'mcmire-context'
require 'context'
gem 'mcmire-matchy'
require 'matchy'
require 'rr-matchy'

require 'rails/init'
#require 'activerecord'
#require 'mcmire/after_timestamps'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
  include RRMatchy
end
