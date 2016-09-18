#encoding: utf-8
#author: shitake
#data: 16-7-8

module Event

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