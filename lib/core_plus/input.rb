#encoding: utf-8
#author: shitake
#data: 16-7-28

# require_relative './api.rb'

module Mouse

  GetMousePos = API.to_api('user32|GetCursorPos|p|i')
  Scr2Cli = API.to_api('user32|ScreenToClient|lp|i')

  class << self

    def get_global_pos
      pos = [0, 0].pack('ll')
      return nil if GetMousePos.call(pos) == 0
      pos.unpack('ll')
    end

    def get_pos
      pos = [0, 0].pack('ll')
      return nil if GetMousePos.call(pos) == 0
      return nil if Scr2Cli.call(API.get_hWnd, pos) == 0
      return [-1, -1] unless API.get_rect.point_hit(*pos.unpack('ll'))
      pos.unpack('ll')
    end

    def mouse_scroll?

    end

    def mouse_scroll_value

    end

    def update

    end

  end
end

module Keyboard

  KEY_VALUE = {
      MOUSE_LB: 0x01,
      MOUSE_RB: 0x02,
      MOUSE_MB: 0x04,

      KEY_BACK: 0x08,
      KEY_TAB: 0x09,

      KEY_CLEAR: 0x0C,
      KEY_ENTER: 0x0D,
      KEY_SHIFT: 0x10,
      KEY_CTRL: 0x11,
      KEY_ALT: 0x12,
      KEY_PAUSE: 0x13,
      KEY_CAPITAL: 0x14, #CAPS LOCK键
      KEY_ESC: 0x1B,
      KEY_SPACE: 0x20,
      KEY_PRIOR: 0x21, #PAGE UP键
      KEY_NEXT: 0x22, #PAGE DOWN键
      KEY_END: 0x23,
      KEY_HOME: 0x24,
      KEY_LEFT: 0x25, #LEFT ARROW键
      KEY_UP: 0x26,
      KEY_RIGHT: 0x27,
      KEY_DOWN: 0x28,
      KEY_SELECT: 0x29,
      KEY_EXECUTE: 0x2B,
      KEY_INS: 0x2D,
      KEY_DEL: 0x2E,
      KEY_HELP: 0x2F,

      KEY_0: 0x30,
      KEY_1: 0x31,
      KEY_2: 0x32,
      KEY_3: 0x33,
      KEY_4: 0x34,
      KEY_5: 0x35,
      KEY_6: 0x36,
      KEY_7: 0x37,
      KEY_8: 0x38,
      KEY_9: 0x39,

      KEY_A: 0x41,
      KEY_B: 0x42,
      KEY_C: 0x43,
      KEY_D: 0x44,
      KEY_E: 0x45,
      KEY_F: 0x46,
      KEY_G: 0x47,
      KEY_H: 0x48,
      KEY_I: 0x49,
      KEY_J: 0x4A,
      KEY_K: 0x4B,
      KEY_L: 0x4C,
      KEY_M: 0x4D,
      KEY_N: 0x4E,
      KEY_O: 0x4F,
      KEY_P: 0x50,
      KEY_Q: 0x51,
      KEY_R: 0x52,
      KEY_S: 0x53,
      KEY_T: 0x54,
      KEY_U: 0x55,
      KEY_V: 0x56,
      KEY_W: 0x57,
      KEY_X: 0x58,
      KEY_Y: 0x59,
      KEY_Z: 0x5A,
      KEY_NUM_0: 0x60,
      KEY_NUM_1: 0x61,
      KEY_NUM_2: 0x62,
      KEY_NUM_3: 0x63,
      KEY_NUM_4: 0x64,
      KEY_NUM_5: 0x65,
      KEY_NUM_6: 0x66,
      KEY_NUM_7: 0x67,
      KEY_NUM_8: 0x68,
      KEY_NUM_9: 0x69,
      KEY_NULTIPLY: 0x6A, #乘号键
      KEY_ADD: 0x6B, #加号键
      KEY_SEPARATOR: 0x6C, #分隔符键
      KEY_SUBTRACT: 0x6D, #减号键
      KEY_DECIMAL: 0x6E, #小数点键
      KEY_DIVIDE: 0x6F, #除号键

      KEY_F1: 0x70,
      KEY_F2: 0x71,
      KEY_F3: 0x72,
      KEY_F4: 0x73,
      KEY_F5: 0x74,
      KEY_F6: 0x75,
      KEY_F7: 0x76,
      KEY_F8: 0x77,
      KEY_F9: 0x78,
      KEY_F10: 0x79,
      KEY_F11: 0x7A,
      KEY_F12: 0x7B,

      KEY_NUMLOCK: 0x90, #NUMLOCK键
      KEY_SCROLL: 0x91, #SCROLL LOCK键
  }

  GetKeyboardState = API.to_api('user32|GetKeyboardState|p|i')

  class << self

    def init
      @old_keyboard_state = @keyboard_state = ' ' * 256
      @keyboard = Hash.new(0)
    end

    def update
      @old_keyboard_state = @keyboard_state
      @keyboard_state = ' ' * 256
      GetKeyboardState.call(@keyboard_state)
      256.times do |i|
        next unless KEY_VALUE.index(i)
        @keyboard[i] = 2 if @keyboard[i] == 1
        @keyboard[i] = 0 if @keyboard[i] == 3
        if @keyboard_state[i] != @old_keyboard_state[i] && @old_keyboard_state[i] != ' '
          case @keyboard[i]
            when 0
              @keyboard[i] = 1
            when 2
              @keyboard[i] = 3
          end
        end
      end
    end

    def hold?(key)
      key = key.to_sym if key.class == String
      value = KEY_VALUE[key]
      (@keyboard[value] == 1 || @keyboard[value] == 2) ? true : false
    end

    def down?(key)
      key = key.to_sym if key.class == String
      value = KEY_VALUE[key]
      @keyboard[value] == 1 ? true : false
    end

    def up?(key)
      key = key.to_sym if key.class == String
      value = KEY_VALUE[key]
      @keyboard[value] == 3 ? true : false
    end

  end

  init

end

module Input
  class << self

    alias :shitake_core_plus_update :update

    def update
      shitake_core_plus_update
      Mouse.update
      Keyboard.update
    end

  end
end