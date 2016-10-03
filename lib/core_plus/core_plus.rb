#encoding: utf-8
#author: shitake
#data: 10-12-20

module API

    @api_cache = {}

    def self.to_api(str)
      @api_cache[str.hash] = Win32API.new(*str.split('|')) unless @api_cache.include? str.hash
      @api_cache[str.hash]
    end

    GetWindowThreadProcessId = self.to_api('user32|GetWindowThreadProcessId|LP|L')
    GetWindow = self.to_api('user32|GetWindow|LL|L')
    GetClassName = self.to_api('user32|GetClassName|LPL|L')
    GetCurrentThreadId = self.to_api('kernel32|GetCurrentThreadId|V|L')
    GetForegroundWindow = self.to_api('user32|GetForegroundWindow|V|L')
    GetClientRect = self.to_api('user32|GetClientRect|lp|i')

    def self.get_hwnd
      # 获取调用线程（RM 的主线程）的进程标识
      threadID = GetCurrentThreadId.call
      # 获取 Z 次序中最靠前的窗口
      hWnd = GetWindow.call(GetForegroundWindow.call, 0)
      # 枚举所有窗口
      while hWnd != 0
        # 如果创建该窗口的线程标识匹配本线程标识
        if threadID == GetWindowThreadProcessId.call(hWnd, 0)
          # 分配一个 11 个字节的缓冲区
          className = ' ' * 11
          # 获取该窗口的类名
          GetClassName.call(hWnd, className, 12)
          # 如果匹配 RGSS Player 则跳出循环
          break if className == 'RGSS Player'
        end
        # 获取下一个窗口
        hWnd = GetWindow.call(hWnd, 2)
      end
      hWnd
    end

    def self.get_rect
      rect = [0, 0, 0, 0].pack('l4')
      GetClientRect.call(API.get_hwnd, rect)
      Rect.array2rect(rect.unpack('l4'))
    end

end

class String

  CP_ACP = 0
  CP_UTF8 = 65001

  def u2s
    m2w = API.to_api 'kernel32|MultiByteToWideChar|ilpipi|i'
    w2m = API.to_api 'kernel32|WideCharToMultiByte|ilpipipp|i'

    len = m2w.call(CP_UTF8, 0, self, -1, nil, 0)
    buf = "\0" * (len*2)
    m2w.call(CP_UTF8, 0, self, -1, buf, buf.size / 2)

    len = w2m.call(CP_ACP, 0, buf, -1, nil, 0, nil, nil)
    ret = "\0" * len
    w2m.call(CP_ACP, 0, buf, -1, ret, ret.size, nil, nil)

     ret
  end

  def s2u
    m2w = API.to_api 'kernel32|MultiByteToWideChar|ilpipi|i'
    w2m = API.to_api 'kernel32|WideCharToMultiByte|ilpipipp|i'

    len = m2w.call(CP_ACP, 0, self, -1, nil, 0)
    buf = "\0" * (len*2)
    m2w.call(CP_ACP, 0, self, -1, buf, buf.size / 2)

    len = w2m.call(CP_UTF8, 0, buf, -1, nil, 0, nil, nil)
    ret = "\0" * len
    w2m.call(CP_UTF8, 0, buf, -1, ret, ret.size, nil, nil)

    ret
  end

  def s2u!
    self[0, length] = s2u
  end

  def u2s!
    self[0, length] = u2s
  end

  def to_api
    API.to_api(self)
  end

end

##==============================================================================
# Class Numeric
#===============================================================================

class Numeric

  #获取小数部分
  def fpart
    self - self.to_i
  end

  # 1 - 小数部分
  def rfpart
    1 - fpart
  end

end

##==============================================================================
# Class Bitmap
#===============================================================================

class Bitmap

  # 分割图片
  def cut_bitmap(width, height, type)
    case type
      when 0
        bitmaps = cut_row(width, height)
      when 1
        bitmaps = cut_rank(width, height)
      when 2
        bitmaps = cut_row_rank(width, height)
      when 3
        bitmaps = cut_rank_row(width, height)
      else
        raise "Error:Bitmap cut type error(#{type})."
    end
    bitmaps
  end

  # 按参数分割图片
  def cut_bitmap_conf(config)
    bitmaps = []
    config.each do |i|
      bitmap = Bitmap.new(i[2], i[3])
      bitmap.blt(0, 0, self, Rect.new(i[0],i[1], i[2], i[3]))
      bitmaps.push(bitmap)
    end
    bitmaps
  end

  def cut_row(width, height)
    number = self.width / width
    bitmaps = []
    number.times do |i|
      dx = width * i
      bitmap = Bitmap.new(width,height)
      bitmap.blt(0, 0, self, Rect.new(dx, 0, width, height))
      bitmaps.push(bitmap)
    end
    bitmaps
  end

  def cut_rank(width, height)
    number = self.height / height
    bitmaps = []
    number.times do |i|
      dx = height * i
      bitmap = Bitmap.new(width,height)
      bitmap.blt(0, 0, self, Rect.new(0, dx, width, height))
      bitmaps.push(bitmap)
    end
    bitmaps
  end

  def cut_row_rank(width, height)
    bitmaps = []
    w_bitmaps = cut_row(width, self.height)
    w_bitmaps.each{ |bitmap| bitmaps += bitmap.cut_rank(width, height) }
    bitmaps
  end

  def cut_rank_row(width, height)
    bitmaps = []
    h_bitmaps = cut_rank(self.width, height)
    h_bitmaps.each{ |bitmap| bitmaps += bitmap.cut_row(width, height) }
    bitmaps
  end

  # 平铺
  def scale9bitmap(a, b, c, d, width, height)
    raise "Error:width值太小!(#{width} < #{self.width})" if width < self.width
    raise "Error:height值太小!(#{height} < #{self.height})" if height < self.height
    w = self.width - a - b
    h = self.height - c - d
    config = [
        [0, 0, a, c],
        [a, 0, w, c],
        [self.width - b, 0, b, c],
        [0, c, a, h],
        [a, c, w, h],
        [self.width - b, c, b, h],
        [0, self.height - d, a, d],
        [a, self.height - d, w, d],
        [self.width - b, self.height - d, b, d]
    ]
    bitmaps = cut_bitmap_conf(config)
    w_number = (width - a - b) / w
    w_yu = (width - a - b) % w
    h_number = (height - c - d) / h
    h_yu = (height - c - d) % h
    bitmap = Bitmap.new(width, height)
    # 中心
    w_number.times do |n|
      h_number.times do | i|
        bitmap.blt(a + n * w, c + i * h, bitmaps[4], bitmaps[4].rect)
        bitmap.blt(a + w_number * w, c + i * h, bitmaps[4], Rect.new(0, 0, w_yu, h)) if n == 0
      end
      bitmap.blt(a + n * w, c + h_number * h, bitmaps[4], Rect.new(0, 0, w, h_yu))
    end
    bitmap.blt(a + w_number * w, c + h_number * h, bitmaps[4], Rect.new(0, 0, w_yu, h_yu))
    #w
    w_number.times do |n|
      bitmap.blt(a + n * w, 0, bitmaps[1], bitmaps[1].rect)
      bitmap.blt(a + n * w, height - d, bitmaps[7], bitmaps[7].rect)
    end
    bitmap.blt(a + w_number * w, 0, bitmaps[1], Rect.new(0, 0, w_yu, c))
    bitmap.blt(a + w_number * w, height - d, bitmaps[7], Rect.new(0, 0, w_yu, d))
    #h
    h_number.times do |n|
      bitmap.blt(0, c + n * h, bitmaps[3], bitmaps[3].rect)
      bitmap.blt(width - b, c + n * h, bitmaps[5], bitmaps[5].rect)
    end
    bitmap.blt(0, c + h_number * h, bitmaps[3], Rect.new(0, 0, a, h_yu))
    bitmap.blt(width - b, c + h_number * h, bitmaps[5], Rect.new(0, 0, b, h_yu))
    # 四角
    bitmap.blt(0, 0, bitmaps[0], bitmaps[0].rect)
    bitmap.blt(width - b, 0, bitmaps[2], bitmaps[2].rect)
    bitmap.blt(0, height - d, bitmaps[6], bitmaps[6].rect)
    bitmap.blt(width - b, height - d, bitmaps[8], bitmaps[8].rect)
    bitmap
  end

  #该函数来自白菜组基础脚本，作者Sion Error
  def draw_line(x1, y1, x2, y2, color)
    dx = x2 - x1
    dy = y2 - y1
    if dx.abs < dy.abs
      t_ = x1; x1 = y1; y1 = t_
      t_ = x2; x2 = y2; y2 = t_
      t_ = dx; dx = dy; dy = t_
    end
    if x2 < x1
      t_ = x1; x1 = x2; x2 = t_
      t_ = y1; y1 = y2; y2 = t_
    end
    set_pixel(x1, y1, color)
    set_pixel(x2, y2, color)
    r = color.red
    g = color.green
    b = color.blue
    a = color.alpha
    gradient = dy.fdiv(dx)
    intery = y1 + gradient
    ((x1 + 1)..(x2 - 1)).each do |x|
      y1 = intery.to_i
      y2 = intery.ceil
      set_pixel(x, y1, Color.new(r, g, b, intery.rfpart * a))
      set_pixel(x, y2, Color.new(r, g, b, intery.fpart * a)) if y1 != y2
      intery = intery + gradient
    end
  end

end

##==============================================================================
# Class: Color
#===============================================================================

class Color

  #Common Color 10
  RED = Color.new(255, 0 ,0)
  ORANGE = Color.new(255, 165, 0)
  YELLOW = Color.new(255, 255, 0)
  GREEN = Color.new(0, 255, 0)
  CHING = Color.new(0, 255, 255)
  BLUE = Color.new(0, 0, 255)
  PURPLE = Color.new(139, 0, 255)
  BLACK = Color.new(0, 0, 0)
  WHITE = Color.new(255 ,255, 255)
  GREY = Color.new(100,100,100)

  #24 Color Ring
  CR1 = Color.new(230, 3, 18)
  CR2 = Color.new(233, 65, 3)
  CR3 = Color.new(240, 126, 15)
  CR4 = Color.new(240, 186, 26)
  CR5 = Color.new(234, 246, 42)
  CR6 = Color.new(183, 241, 19)
  CR7 = Color.new(122, 237, 0)
  CR8 = Color.new(62, 234, 2)
  CR9 = Color.new(50, 198, 18)
  CR10 = Color.new(51, 202, 73)
  CR11 = Color.new(56, 203, 135)
  CR12 = Color.new(60, 194, 197)
  CR13 = Color.new(65, 190, 255)
  CR14 = Color.new(46, 153, 255)
  CR15 = Color.new(31, 107, 242)
  CR16 = Color.new(10, 53, 231)
  CR17 = Color.new(0, 4, 191)
  CR18 = Color.new(56, 0, 223)
  CR19 = Color.new(111, 0, 223)
  CR20 = Color.new(190, 4, 220)
  CR21 = Color.new(227, 7, 213)
  CR22 = Color.new(226, 7, 169)
  CR23 = Color.new(227, 3, 115)
  CR24 = Color.new(227, 2, 58)

  #32 Gray Level
  GL1 = Color.new(0, 0, 0)
  GL2 = Color.new(8, 8, 8)
  GL3 = Color.new(16, 16, 16)
  GL4 = Color.new(24, 24, 24)
  GL5 = Color.new(32, 32, 32)
  GL6 = Color.new(40, 40, 40)
  GL7 = Color.new(48, 48, 48)
  GL8 = Color.new(56, 56, 56)
  GL9 = Color.new(64, 64, 64)
  GL10 = Color.new(72, 72, 72)
  GL11 = Color.new(80, 80, 80)
  GL12 = Color.new(88, 88, 88)
  GL13 = Color.new(96, 96, 96)
  GL14 = Color.new(104, 104, 104)
  GL15 = Color.new(112, 112, 112)
  GL16 = Color.new(120, 120, 120)
  GL17 = Color.new(128, 128, 128)
  GL18 = Color.new(136, 136, 136)
  GL19 = Color.new(144, 144, 144)
  GL20 = Color.new(152, 152, 152)
  GL21 = Color.new(160, 160, 160)
  GL22 = Color.new(168, 168, 168)
  GL23 = Color.new(176, 176, 176)
  GL24 = Color.new(184, 184, 184)
  GL25 = Color.new(192, 192, 192)
  GL26 = Color.new(200, 200, 200)
  GL27 = Color.new(208, 208, 208)
  GL28 = Color.new(216, 216, 216)
  GL29 = Color.new(224, 224, 224)
  GL30 = Color.new(232, 232, 232)
  GL31 = Color.new(240, 240, 240)
  GL32 = Color.new(248, 248, 248)

  def self.str2color(str)
    regexp = /rgba\(( *[0-9]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]),( *[0-9]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]),( *[0-9]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]),( *[0-9]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\)/
    raise "Error:Color string error(#{str})." if str[regexp]
    Color.new($1.to_i, $2.to_i, $3.to_i, $4.to_i)
  end

  def self.hex2color(hex)
    regexp = /#([0-9a-f]|[0-9a-f][0-9a-f])([0-9a-f]|[0-9a-f][0-9a-f])([0-9a-f]|[0-9a-f][0-9a-f])/
    raise "Error:Color hex string error(#{hex})." if hex[regexp]
    Color.new($1.to_i(16), $2.to_i(16), $3.to_i(16))
  end

  def inverse
    Color.new(255 - self.red, 255 - self.green, 255 - self.blue, self.alpha)
  end

  def to_rgba
    "rgba(#{self.red.to_i}, #{self.green.to_i}, #{self.blue.to_i}, #{self.alpha.to_i})"
  end

  def to_hex
    sprintf('#%02x%02x%02x', self.red, self.green, self.blue)
  end

end

##==============================================================================
# Rect
#===============================================================================

class Rect

  def self.array2rect(array)
    Rect.new(array[0], array[1], array[2], array[3])
  end

  def rect2array
    [self.x, self.y, self.width, self.height]
  end

  def point_hit(x, y)

    self.x <= x && x <= self.width && self.y <= y && y <= self.height
  end

  def rect_hit(rect)
    rect.x < self.x + self.width || rect.y < self.y + self.height || rect.x + rect.width > self.x || rect.y + rect.height > self.y
  end

end

##==============================================================================
# Viewport
#===============================================================================

class Viewport

  attr_reader :list

  alias :shitake_core_plus_initialize :initialize

  def initialize(*arg)
    shitake_core_plus_initialize(*arg)
    @list = []
  end

  def add_child(obj)
    @list.push(obj)
  end

  def remove_child(obj)
    @list.delete(obj)
  end

end

##==============================================================================
# Sprite
##==============================================================================

class Sprite

  alias :shitake_core_plus_initialize :initialize

  def initialize(viewport = nil)
    shitake_core_plus_initialize(viewport)
    viewport.add_child(self) if viewport
  end

  alias :shitake_core_plus_viewport= :viewport=

  def viewport=(value)
    self.viewport.remove_child(self) if self.viewport
    self.shitake_core_plus_viewport = value
    value.add_child(self)
  end


end

##==============================================================================
# Animation
#===============================================================================

class Animation < Sprite

  attr_reader :status
  attr_accessor :bitmaps

  def initialize(bitmaps, viewport = nil)
    super(viewport)
    @bitmaps = bitmaps
    @index = nil
    @num = nil
    @status = 0
  end

  def play(x, y, frame_speed, start_frame, end_frame, reverse = false, loop = false)
    raise "Error:结束帧大于起始帧！(#{start_frame},#{end_frame})" if start_frame > end_frame
    @status = 1
    @reverse = reverse
    @loop = loop
    @fist_frame = (!@reverse ? start_frame : end_frame)
    @end_frame = (@reverse ? start_frame : end_frame)
    @index = @fist_frame
    @frame_speed = frame_speed
    self.bitmap = @bitmaps[@index]
    self.x = x
    self.y = y
    @duration = @frame_speed
  end

  def frame
    @index
  end

  def dispose
    super
    @bitmaps.each{ |bitmap| bitmap.dispose unless bitmap.disposed? }
  end

  def update
    super
    return if @status == 0
    # print @index
    @duration -= 1
    return if @duration != 0
    next_frame
    @duration = @frame_speed
  end

  def next_frame
    if @index == @end_frame
      if @loop
        @index = @fist_frame
      else
        @index = nil
        @status == 0
      end
    else
      @index += (@reverse ? -1 : 1)
    end
    self.bitmap = @bitmaps[@index]
  end

end

##==============================================================================
# Timer
#===============================================================================

class Timer

  @@list = []

  def self.update
    @@list.each{|o| o.update if o != nil } if @@list != []
  end

  attr_reader :status

  TimerEvent = Struct.new(:start_time, :time, :block)

  def initialize
    @@list.push(self)
    @afters = []
    @everys = []
    @status = :run
    @stops_time = 0
  end

  def start
    return if @status == :run
    @stops_time += Time.now - @stop_time
    @status = :run
  end

  def stop
    return if @status == :stop
    @stop_time = Time.now
    @status = :stop
  end

  def after(time, &block)
    @afters.push object = TimerEvent.new(Time.now, time, block)
    object
  end

  def every(time, &block)
    @everys.push object = TimerEvent.new(Time.now, time, block)
    object
  end

  def delete_every(object)
    @everys.each do |o|
      @everys.delete(o) if o == object
    end
  end

  def delete_after(object)
    @afters.each do |o|
      @afters.delete(o) if o == object
    end
  end

  def dispose
    @@list.delete(self)
    @afters.clear
    @everys.clear
  end

  def update_afters
    return if @afters == []
    @afters.each do |o|
      if Time.now - o.start_time - @stops_time >= o.time
        o.block.call
        @afters.delete(o)
      end
    end
  end

  def update_everys
    return if @everys == []
    @everys.each do |o|
      if Time.now - o.start_time - @stops_time >= o.time
        o.block.call
        o.start_time = Time.now
        @stops_time = 0
      end
    end
  end

  def update
    update_afters
    update_everys
  end

end

##==============================================================================
# Mouse
#===============================================================================

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
      return nil if Scr2Cli.call(API.get_hwnd, pos) == 0
      return [-1, -1] unless API.get_rect.point_hit(*pos.unpack('ll'))
      pos.unpack('ll')
    end

    def scroll?
      false
    end

    def scroll_value
      0
    end

  end
end

##==============================================================================
# Keyboard
#===============================================================================

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

    def press?(key)
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

##==============================================================================
# Input
#===============================================================================

module Input
  class << self

    alias :shitake_core_plus_update :update

    def update
      shitake_core_plus_update
      Keyboard.update
    end

  end
end