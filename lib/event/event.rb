#encoding: utf-8
#author: shitake
#data: 16-7-8

require_relative 'event_callback_fiber'
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

event = Event::EventManger.new

event.on(:shit){|em|
  p em.this
  em.wait(2)
  p 233
  em.delete
  p event.trigger(:shit)
}

event.trigger(:shit)

loop{
  event.update
}