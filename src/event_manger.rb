#encoding: utf-8
#author: shitake
#data: 16-4-20

require '../lib/event/event'
require '../lib/core_plus/core_plus'

module RGUI

  class EventManger < Event::EventManger

    def update
      super
      if @object.status && @object.visible
        mouse_update
        @keyboard_events.each_value { |o| keyboard_update(o) }
      end
    end

    def mouse_update
      x, y = Mouse.get_pos
      rect = @object.rect
      if !@mouse_focus && rect.point_hit(x, y)
        trigger('mouse_in', {:x=>x, :y=>y})
        @mouse_focus = true
      elsif @mouse_focus && !rect.point_hit(x, y)
        trigger('mouse_out', {:x=>x, :y=>y})
        @mouse_focus = false
      end
      trigger('mouse_scroll', {:value => Mouse.scroll_value}) if Mouse.scroll?
    end

    def keyboard_update(event)
      type, name = event.name,split('|')
      return if name['MOUSE'] && !@mouse_focus
      case type
        when 'keydown'
          trigger(event.name) if Keyboard.down?(name)
        when 'keypress'
          trigger(event.name) if Keyboard.press?(name)
        when 'keyup'
          trigger(event.name) if Keyboard.up?(name)
        else
          raise 'Error:Keyboard event type error!'
      end
    end

    def mouse_event?(event_name)
      %w(mouse_in mouse_out mouse_scroll).include?(event_name)
    end

    def keyboard_events?(event_name)
      event_name['keydown'] || event_name['keypress'] || event_name['keyup']
    end

    def on(name, index = nil, &callback)
      name = 'keydown|MOUSE_LB' if name == 'click'
      type = 0
      type = 1 if mouse_event?(name)
      type = 2 if keyboard_events?(name)
      super(name, index, type, &callback)
      @keyboard_events.push(@events[name]) if type == 2
    end

  end

end