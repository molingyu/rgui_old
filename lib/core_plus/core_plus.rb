#encoding: utf-8
#author: shitake
#data: 10-12-20
##==============================================================================
# Class Numeric
#=============================================================================== 
# Methods:
#-------------------------------------------------------------------------------
#   fpart
#     获取小数部分
#-------------------------------------------------------------------------------
#   rfpart
#     1 - 小数部分
##==============================================================================

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
# Methods:
#-------------------------------------------------------------------------------
#   cut_bitmap(width, height, type)
#     图片分割，将图片切割成指定大小并返回一个Bitmap数组。切割方式取决于type参数。
#     width:每个小图的宽度。
#     height:每个小图的高度。
#     type:分割方式。0按行分割；1按列分割；2先按行分割，再按列分割；3先按列分割，再
#     按行分割
#-------------------------------------------------------------------------------
#   cut_bitmap_conf(config)
#     图片分割，将图片按参数数组所指定的大小进行分割。不同于cut_bitmap的是，每个分割
#     后的图片大小并不一定相等。
#     config:一个记录每个分割后图片位置的双重数组（[[x, y, width, height], ...])。
##==============================================================================

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
        raise "Error: Bitmap cut type error(#{type})."
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
    raise "width值太小!(#{width} < #{self.width})" if width < self.width
    raise "height值太小!(#{height} < #{self.height})" if height < self.height
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
  
  #该函数来自白菜组基础脚本，作者Sion
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
    for x in (x1 + 1)..(x2 - 1)
      y1 = intery.to_i
      y2 = intery.ceil
      set_pixel(x, y1, Color.new(r,g,b, intery.rfpart * a))
      set_pixel(x, y2, Color.new(r,g,b, intery.fpart * a)) if y1 != y2
      intery = intery + gradient
    end
  end

end 

##==============================================================================
# Class: Color
#=============================================================================== 
# Constants:
#-------------------------------------------------------------------------------
# 十基本色：
#   RED  红  ORANGE　橙　  YELLOW　黄　 GREEN　绿　 CHING　青　
#   BLUE 蓝   PURPLE  紫　  BLACK　黑　 WHITE　白　 GREY　 灰
# 十二色环:
#   CR1~CR12
# 三十二灰阶：
#   GL1~GL32
#-------------------------------------------------------------------------------
# Class Methods:
#-------------------------------------------------------------------------------
#   str2color(str)
#     将一个形如'rgba(xx, xx, xx, xx)'的字符串转换为一个Color对象。
#     str:欲转换的字符串。
#-------------------------------------------------------------------------------
#   hex2color(hex)
#     从十六进制颜色码创建Color对象。
#-------------------------------------------------------------------------------
# Methods:
#-------------------------------------------------------------------------------
#   inverse
#     取该颜色的反色。
#-------------------------------------------------------------------------------
#   to_rgba
#     以'rgba(xx, xx, xx, xx, xx)'的形式输出该颜色值。
#-------------------------------------------------------------------------------
#   to_hex
#     输出该对象所对应的十六进制颜色码，忽略alpha值。
##==============================================================================

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
    "rgba(#{self.red}, #{self.green}, #{self.blue}, #{self.alpha})"
  end
  
  def to_hex
    sprintf('#%02x%02x%02x', self.red, self.green, self.blue)
  end
  
end

##==============================================================================
# Rect
#===============================================================================
# Class Methods:
#-------------------------------------------------------------------------------
#   array2rect(array)
#     将一个形如[x, y, width, height]的数组转换为一个Rect对象。
#     array:欲转换的数组。
#-------------------------------------------------------------------------------
# Methods:
#-------------------------------------------------------------------------------
#   rect2array
#     将一个rect对象转换为形如[x, y, width, height]形式的数组。
#-------------------------------------------------------------------------------
#   point_hit(x, y)
#     判断点是否在rect内，若在则返回true，否则false。
#     x:欲检测点的x坐标。
#     y:欲检测点的y坐标。
#-------------------------------------------------------------------------------
#   rect_hit(rect)
#     判断两个rect是否相交，若相交则返回true，否则false。
#     rect:欲判断的另一个rect对象。
##==============================================================================

class Rect
  
  def self.array2rect(array)
    Rect.new(array[0], array[1], array[2], array[3])
  end

  def rect2array
    [self.x, self.y, self.width, self.height]
  end

  def point_hit(x, y)
    self.x <= x <= self.width && self.y <= y <= self.height
  end

  def rect_hit(rect)
    rect.x < self.x + self.width || rect.y < self.y + self.height || rect.x + rect.width > self.x || rect.y + rect.height > self.y
  end
  
end

##==============================================================================
# Viewport
#===============================================================================
# Attributes:
#-------------------------------------------------------------------------------
#   list [R]
#     该viewport对象内的所有sprite对象索引数组。
#-------------------------------------------------------------------------------
# Methods:
#-------------------------------------------------------------------------------
#   rect2array
#     将一个rect对象转换为形如[x, y, width, height]形式的数组。
#-------------------------------------------------------------------------------
#   add_child(obj)
#     将指定对象加添加到list中。
#     obj:欲添加的对象。
#-------------------------------------------------------------------------------
#   remove_child(obj)
#     将指定对象从list中移除。
#     obj:欲移除的对象。
##==============================================================================

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
    shitake_core_plus_viewport=(value)
    value.add_child(self)
  end


end

##==============================================================================
# Animation
#===============================================================================
# Attributes:
#-------------------------------------------------------------------------------
#   list [R]
#     该viewport对象内的所有sprite对象索引数组。
#-------------------------------------------------------------------------------
# Class Methods:
#-------------------------------------------------------------------------------
#   new(bitmaps, [viewport])
#     创建一个序列图动画对象。
#     bitmaps:序列图bitmap对象数组。
#     viewport:指定的viewport对象。
#-------------------------------------------------------------------------------
# Methods:
#-------------------------------------------------------------------------------
#   play(x, y, frame_speed, fist_frame, end_frame, reverse = false, loop = false)
#     以指定帧速播放帧动画，播放区间由起始帧和结束帧指定，可循环和反向播放。
#     obj:欲添加的对象。
#-------------------------------------------------------------------------------
#   remove_child(obj)
#     将指定对象从list中移除。
#     obj:欲移除的对象。
##==============================================================================

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

  def play(x, y, frame_speed, fist_frame, end_frame, reverse = false, loop = false)
    raise "Error:结束帧大于起始帧！(#{fist_frame},#{end_frame})" if fist_frame > end_frame
    @status = 1
    @reverse = reverse
    @loop = loop
    @fist_frame = (!@reverse ? fist_frame : end_frame)
    @end_frame = (@reverse ? fist_frame : end_frame)
    @index = @fist_frame
    @num = end_frame - fist_frame
    @frame_speed = frame_speed
    self.bitmap = @bitmaps[@index]
    self.x = x
    self.y = y
    @duration = @frame_speed
  end

  def frame
    @index
  end

  def update
    super
    return if @status == 0
    return @status = 0 unless @num
    @duration -= 1
    return if @duration != 0
    next_frame
    @duration = @frame_speed
  end

  def next_frame
    @index += (@reverse ? -1 : 1)
    self.bitmap = @bitmaps[@index]
    if @index == (@reverse ? 0 : @num)
      if @loop
        @index = @fist_frame
      else
        @num = nil
        @index = nil
      end
    end
  end

end

module Input
  
  class << self
    
    def mouse_pos
      
    end
    
  end
  
end