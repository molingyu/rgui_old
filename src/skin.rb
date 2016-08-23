#encoding: utf-8
#author: shitake
#data: 16-7-28

module RGUI

  class Skin

    def initialize(name)
      @path = RGUI.SKIN_PATH + name
      read_controls
    end

    def read_controls

    end

  end

end