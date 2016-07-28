#encoding: utf-8
#author: shitake
#data: 16-7-8

require_relative 'event_fiber'
require_relative 'event_manger'

module Event

  VERSION = '1.0.0'

  class Event

    attr_reader :name
    attr_reader :type

    def initialize(name, type)
      @name = name
      @type = type
      @callback = []
    end

    def length
      @callback.length
    end

    def push(value)
      @callback.push(value)
    end

    def each(&block)
      @callback.each{ |callback| yield callback }
    end

    def []=(index, value)
      @callback[index] = value
    end

    def delete(value)
      @callback.delete(value)
    end

    def clear
      @callback.clear
    end
  end

end
