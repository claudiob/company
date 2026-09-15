require 'simplecov'
SimpleCov.start { minimum_coverage 100 }

require 'minitest/autorun'

require_relative '../lib/company'

# The tests date their records in months and years, which the gem itself never counts in.
require 'active_support/core_ext/integer/time'

# A reference gem, written with nothing but the hooks a real one writes.
%w[business jobs technicians visits leads account].each { |file| require_relative "acme/#{file}" }
