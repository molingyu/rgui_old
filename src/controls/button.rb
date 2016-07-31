#encoding: utf-8
#author: shitake
#data: 16-4-20

require_relative '../base'

module RGUI

  class Button < RGUI::Base

    attr_reader :state
    attr_reader :font_bitmap
    attr_reader :bitmaps
    attr_reader :sprite

    def state=(value)
      return unless @state_list.include?(value)
      return if @state == value
      old = @state
      @state = value
      state_change
      @event.trigger('change_state', {:old => old, :new => @state })
    end

    def initialize(object = {})
      @state = object[:state] || :default
      @state_list = [:default, :focus, :down, :disable]
      @bitmaps = object[:bitmaps]
      super(object)
    end

    def def_event_callback
      @event.on_mouse('mouse_in'){ self.state = :focus }
      @event.on_mouse('mouse_out'){ self.state = :default }
      @event.on_mouse('click'){ self.state = :down }
      @event.on('enable'){ self.state = :default }
      @event.on('disable'){ self.state = :disable }
      @event.on('change_x'){ @sprite.x = @x }
      @event.on('change_y'){ @sprite.y = @y }
      @event.on('change_z'){ @sprite.z = @z }
      @event.on('change_width'){ self.change_size }
      @event.on('change_height'){ self.change_size }
      @event.on('change_viewport'){ @sprite.viewport = @viewport }
      @event.on('change_visible'){ @sprite.visible = @visible }
      @event.on('change_opacity'){ @sprite.opacity = @opacity }
    end

    def bitmap
      @bitmaps[@state] if @bitmaps
    end

    def change_size
      bitmap = Bitmap.new(@width, @height)
      src_bitmap = @sprite.bitmap
      bitmap.stretch_blt(bitmap.rect, src_bitmap, @rect)
      src_bitmap.dispose
      @sprite.bitmap = bitmap
    end

    def create
      @sprite = Sprite.new(@viewport)
      @z ? @sprite.z = @z : @z = @sprite.z
      update_bitmap
      super
    end

    def update_bitmap
      return if @sprite.bitmap.object_id == bitmap.object_id
      @sprite.bitmap = bitmap
      @width = @sprite.bitmap.width
      @height = @sprite.bitmap.height
    end

    def update
      super
      #update_bitmap
    end

    def dispose
      @bitmaps.each_value{ |o| o.dispose if o }
      @font_bitmap.dispose if @font_bitmap
      @sprite.dispose
      super
    end

    def disposed?
      @bitmaps.each_value{ |o| return false unless o && o.disposed? } && (@font_bitmap.dispose if @font_bitmap) == true
    end

    def state_change
      @sprite.bitmap = bitmap
    end

  end

end