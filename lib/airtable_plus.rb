require "airtable_plus/version"
require 'airtable'
require 'active_support/all'

class AirtablePlus
  autoload 'Mapper', 'airtable_plus/mapper'
  
  attr_accessor :mapper
  
  attr_accessor :records
  
  def initialize(api_key, app_id, worksheet_name)
    @client = ::Airtable::Client.new(api_key)
    @table = @client.table(app_id, worksheet_name)
    @mapper = Mapper.new
  end
  
  def klass=(klass)
    @mapper.klass = klass
  end
  
  def attr_table=(attr_table)
    @mapper.attr_table = attr_table
  end
  
  def ignore_attrs=(attrs)
    @mapper.ignore_attrs = attrs
  end
  
  def records
    @records ||= @table.all
  end
  
  def list
    records.map(&:repo)
  end
  
  def all
    records.map {|record| @mapper.mapping(record)}
  end
  
  def add(instance)
    record = Airtable::Record.new(@mapper.convert_to_h(instance))
    @table.create(record)
  end
  
  def update(instance)
    record = records.find {|r| r.repo == repo.name }
    return record.nil?
    @table.update(record)
  end
end
