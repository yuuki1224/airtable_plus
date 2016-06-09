
class AirtablePlus
  class Mapper
    
    attr_accessor :klass
    
    attr_accessor :attr_table
    
    attr_accessor :ignore_attrs
    
    # AirTable::Record class
    def mapping(record)
      raise "Please set @klass instance" if @klass.nil?
      
      @klass.new.tap do |instance|
        record.fields.each do |key, value|
          next if @ignore_attrs.include?(key)
          table_value = attr_table[key.to_sym]
          
          if table_value.is_a?(String)
            attr_name = table_value
          else
            attr_name = table_value[:name]
            value = table_value[:proc].call(value)
          end
          
          begin
            instance.send("#{attr_name}=", value)
          rescue NoMethodError => e
            puts "#{key} isn't defined in @attr_table."
            exit 1
          rescue Exception => e
            # binding.pry
          end
          
        end
      end
    end
    
    def convert_to_h(instance)
      @attr_table.reduce({}) do |h, pair|
        h[pair.first] = instance.send(pair.last).to_s
      end
    end
  end
end
