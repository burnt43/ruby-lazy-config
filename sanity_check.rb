require './lib/ruby-lazy-config'

ActiveSupport::Concern
ActiveSupport::Inflector.underscore('SomeString')
{}.with_indifferent_access

puts "\033[0;32mOK\033[0;0m"
