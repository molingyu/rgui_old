#encoding: utf-8
#author: shitake
#data: 16-4-20

module RGUI

  class Base
    attr_reader :UID
    attr_reader :x
    attr_reader :y
    attr_reader :z
    attr_reader :width
    attr_reader :height
    attr_reader :rect
    attr_reader :viewport
    attr_reader :focus
    attr_reader :visible
    attr_reader :opacity
    attr_reader :status
    attr_reader :parent
    attr_reader :children
    attr_reader :event

    def x=(value)
      return if @x == value
      old = @x
      @x = value
      @rect.x = @x
      @event.trigger('change_x', {:old => old, :new => @x})
    end

    def y=(value)
      return if @y == value
      old = @y
      @y = value
      @rect.y = @y
      @event.trigger('change_y', {:old => old, :new => @y})
    end

    def z=(value)
      return if @z == value
      old = @z
      @z = value
      @event.trigger('change_z', {:old => old, :new => @z})
    end

    def width=(value)
      return if @width == value
      old = @width
      @width = value
      @rect.width = @width
      @event.trigger('change_width', {:old => old, :new => @width})
    end

    def height=(value)
      return if @height == value
      old = @height
      @height = value
      @rect.height = @height
      @event.trigger('change_height', {:old => old, :new => @height})
    end

    def rect=(value)
      return if @rect == value
      old = @rect.clone
      @rect = value
      self.x = @rect.x
      self.y = @rect.y
      self.width = @rect.width
      self.height = @rect.height
      @event.trigger('change_rect', {:old => old, :new => @rect.clone})
    end

    def viewport=(value)
      return if @viewport == value
      old = @viewport.clone
      @viewport = value
      @event.trigger('change_viewport', {:old => old, :new => @viewport.clone})
    end

    def focus=(value)
      return if @focus == value
      old = @focus
      @focus = RGUI.true_false(value)
      @event.trigger('change_focus', {:old => old, :new => @focus})
    end

    def visible=(value)
      return if @visible == value
      old = @visible
      @visible = RGUI.true_false(value)
      @event.trigger('change_visible', {:old => old, :new => @visible})
    end

    def status=(value)
      return if @status == value
      old = @status
      @status = RGUI.true_false(value)
      @event.trigger('change_status', {:old => old, :new => @status})
    end

    def opacity=(value)
      return if value == value
      old = @opacity
      @opacity = RGUI.border(0, 255, value)
      @event.trigger('change_opacity', {:old => old, :new => @opacity})
    end

    def parent=(value)
      return if @parent != value
      @parent = value
      @event.trigger('change_parent')
    end

    def initialize(object = {})
      @UID = RGUI.get_id
      # @theme = object[:theme] || RGUI::Theme.new(GUI.defaultTheme)
      @x = object[:x] || 0
      @y = object[:y] || 0
      @z = object[:z]
      @width = object[:width] || 0
      @height = object[:height] || 0
      @rect = Rect.new(@x, @y, @width, @height)
      @viewport = object[:viewport]
      @z = @viewport.z if @viewport
      @focus = object[:focus] == true
      @visible = object[:visible] != false
      @opacity = object[:opacity] if 255
      @status = object[:status] != false
      @parent = object[:parent]
      @event = RGUI::EventManger.new(self)
      @action_index = 0
      @action_list = object[:action_list]
      def_event_callback
    end

    def def_event_callback
    end

    def action
      return unless @action_list
      @event.trigger('action_start').clear if @action_index == 0
      if @action_index == @action_list.length - 1
        @action_index = 0
        @action_list = nil
        @event.trigger('action_end').clear
        return
      end
      if @action_list[@action_index][:index] == @action_index
        action_update(@action_list[@action_index])
      end
      @action_index += 1
    end

    def action_update(params)
    end

    def create
      @event.trigger('create')
    end

    def update
      action if @action_list
      @event.update
    end

    def close
      @event.trigger('close')
      if @action_list
        @event.on('action_end') { self.dispose }
      else
        dispose
      end
    end

    def dispose
      @event.trigger('dispose') unless disposed?
    end

    def disposed?
    end

    def get_focus
      return if @focus
      self.focus = true
      @event.trigger('get_focus')
    end

    def lost_focus
      return unless @focus
      self.focus = false
      @event.trigger('lost_focus')
    end

    def show
      return if @visible
      self.visible = true
      @event.trigger('show')
    end

    def hide
      return unless @visible
      self.visible = false
      @event.trigger('hide')
    end

    def enable
      return if @status
      self.status = true
      @event.trigger('enable')
    end

    def disable
      return unless @status
      self.status = false
      @event.trigger('disable')
    end

    def _move_
      @rect.x = @x
      @rect.y = @y
    end

    def move(x, y = x)
      return if x == 0 && y == 0
      old = @rect.clone
      self.x += x
      self.y += y || x
      _move_
      @event.trigger('move', {:old => old, :new => @rect.clone})
    end

    def move_to(x, y = x)
      return if @x == x && @y == y
      old = @rect.clone
      self.x = x
      self.y = y
      _move_
      @event.trigger('move_to', {:old => old, :new => @rect.clone})
    end

    def change_size(width, height = width)
      return if @width == width && @height == height
      old = @rect.clone
      self.width = width
      self.height = height
      @rect.width = @width
      @rect.height = @height
      @event.trigger('change_size', {:old => old, :new => @rect.clone})
    end
  end
end