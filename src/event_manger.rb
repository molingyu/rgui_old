#encoding: utf-8
#author: shitake
#data: 16-4-20

require '../lib/event/event'

module RGUI

  class EventManger < Event::EventManger

    def initialize
      super
      @key_name = [
          build = 233
      ]
      @mouse_events = [

      ]
    end

    def update
      super
      mouse_update
      keyboard_update
    end

  end

end