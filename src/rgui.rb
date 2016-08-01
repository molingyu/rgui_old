#encoding: utf-8
#author: shitake
#data: 16-4-16

module RGUI
  
  VERSION = '0.1.0'

  class << self
    
    attr_reader :NEXT_ID
    attr_accessor :MOUSE?, :KEYBOARD?, :PATH, :CONTROLS, :SKIN_PATH

    def get_id
      RGUI.NEXT_ID += 1
    end

    def hit(x, y, rect)
      rect.x < x && x < rect.x + rect.width && rect.y < y && y < rect.y + rect.height
    end

    def border(min, max, val)
      if val < min
        min
      else
        val > max ? max : val
      end
    end

    def true_false(value)
      if value == nil
        false
      else
        true
      end
    end

    def get_path
      Dir.glob(RGUI.PATH + '/controls/*.rb')
    end

    def auto_load
      require_relative 'base.rb'
      require_relative 'event_manger.rb'
      raise "error: RGUI.PATH error!(#{RGUI.PATH})" if get_path == []
      get_path.each{|path| require path }
      RGUI.CONTROLS = get_path.length
    end

    def say_hello
      chr = '='
      length = 50
      size = length - chr.length * 2
      str = 'Thank you for using RGUI!'
      puts chr * length + "\n" + \
      chr + 'RPG Maker VX Ace GUI framework'.center(size) + chr + "\n" + \
      chr + '-' * size + chr + "\n" + \
      chr + 'author:shitake license:MIT'.center(size) + chr + "\n" + \
      chr + "version:#{RGUI::VERSION} controls:#{RGUI.CONTROLS}".center(size) + chr + "\n" + \
      chr + 'http://rgui.shitake.me && http://rm.66rpg.com'.center(size)+ chr + "\n" + \
      chr * length + "\n" + \
      str.insert(str.size < length ? str.size : length-1, str.size < length ? "\n" : "-\n")
    end

    def init
      RGUI.MOUSE? = true
      RGUI.KEYBOARD? = true
      RGUI.CONTROLS = 0
      RGUI.NEXT_ID = 0
      auto_load
      say_hello
    end

  end

end