#encoding: utf-8
#author: shitake
#data: 2016.09.03

module CSV
  class << self

    def csv2object(str, template = Class.new)
      data = str2table(str)
      object_array = []
      fields = data[0]
      types = data[1]
      fields.each do |key|
        template.send(:attr_accessor, key.to_sym)
      end
      data = data[2,data.size - 2]
      value = ''
      data.each do |record|
        object = template.new.clone
        fields.each_index do |index|
          case types[index]
            when 'String'
              value = record[index]
            when 'Float'
              value = record[index].to_f
            when 'Int'
              value = record[index].to_i
            when 'Boolean'
              value = eval(record[index].downcase)
            when 'Nil'
              value = nil
            else
              raise "Error: error data type(#{types[index]})!"
          end
          key = fields[index].chomp
          object.instance_variable_set(('@' + key).to_sym, value)
        end
        object_array.push(object)
      end
      object_array
    end

    def str2table(str)
      data_table = []
      str.split("\n").each{|i| data_table.push(i.split(','))}
      data_table
    end

  end
end

module Kernel
  def csv(value)
    CSV.csv2object(value)
  end
end