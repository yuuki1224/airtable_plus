require 'airtable_plus'
require 'minitest/pride'
require 'minitest/autorun'
require 'pry'

require_relative './sample_class/repository'

def sample_record
  record = Airtable::Record.new
  binding.pry
end
