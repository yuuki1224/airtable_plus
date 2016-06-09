require "airtable_plus/version"
require 'airtable'
require 'active_support/all'

class AirtablePlus
  autoload 'Mapper', 'airtable_plus/mapper'
  
  DEFAULT_ID_FIELD = 'id'.freeze
  
  attr_accessor :mapper
  
  attr_accessor :records
  
  attr_accessor :id_field
  
  def initialize(api_key, app_id, worksheet_name)
    @client = ::Airtable::Client.new(api_key)
    @table = @client.table(app_id, worksheet_name)
    @mapper = Mapper.new
    
    @id_field = DEFAULT_ID_FIELD
  end
  
  def klass=(klass)
    @mapper.klass = klass
    @mapper.klass.send(:attr_accessor, @id_field)
  end
  
  def attr_table=(attr_table)
    @mapper.attr_table = attr_table
  end
  
  def ignore_attrs=(attrs)
    @mapper.ignore_attrs = attrs
  end
  
  def id_field=(id_field)
    @id_field = id_field
    @mapper.klass.send(:attr_accessor, @id_field)
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
  
  def has?(instance)
  end
  
  # instance: Object or Array[Object]
  def add(instance)
    # record = Airtable::Record.new(@mapper.convert_to_h(instance))
    record = instance.to_record
    @table.create(record)
  end
  
  # instance: Object or Array[Object]
  def delete(instance)
  end
  
  # instance: Object or Array[Object]
  def update(instance)
    record = records.find {|r| r.repo == repo.name }
    return record.nil?
    @table.update(record)
  end
  
  # instance: Object or Array[Object]
  def update_or_add(instance)
    has?(instance) ? update(instance) : add(instance)
  end
end
