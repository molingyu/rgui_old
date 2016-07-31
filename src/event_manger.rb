#encoding: utf-8
#author: shitake
#data: 16-4-20

require '../lib/event/event'

module RGUI

  class EventManger < Event::EventManger

    def initialize
      super
      @keyboard_events = [

      ]
      @mouse_events = [

      ]
    end

    def update
      super
      mouse_update
      keyboard_update
    end

    def mouse_update

    end

    def keyboard_update

    end

    def on(name, index = nil, &callback)
      type = 2
      type = 0 if @mouse_events[name]
      type = 1 if @keyboard_events[name]
      super(name, index, type, &callback)
    end

  end

end