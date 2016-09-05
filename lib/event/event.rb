#encoding: utf-8
#author: shitake
#data: 16-7-8

require_relative 'event_call_back_fiber'
require_relative 'event_manger'

module Event

  VERSION = '1.0.0'

  class Event < Array

    attr_reader :name
    attr_reader :type

    def initialize(name, type)
      super()
      @name = name
      @type = type
    end

  end

end
