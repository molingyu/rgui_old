#encoding: utf-8
# RGSS（Ruby Game Scripting System），也就是「Ruby游戏脚本系统」，使用面向对象脚本语言 Ruby 来开发 Windows® 平台的2D游戏。
# RGSS3 即RGSS系列的第三代产品。（对应的 RPG Maker 作品为 RPG Maker VX Ace）
# === Author
# ©2011 ENTERBRAIN, INC./YOJI OJIMA <www.rpgmakerweb.com>
# === Doc Author
# shitake <http://rm.66rpg.com>
module RGSS3

  # 位图类。位图表示图像的数据。
  # 在画面上显示位图，必须使用精灵（Sprite）之类的对象。
  # 超类：Object。
  #
  class Bitmap

    # 使用 draw_text 方法描绘字符串时所使用的字体（Font）。
    attr_accessor :font

    # Bitmap.new(filename)    -> self
    #   载入由 filename 参数所指定的图像，生成一个 Bitmap 对象。
    #   RGSS-RTP 和加密档案中的文件会自动搜索。扩展名可以省略。
    #
    # Bitmap.new(width, height)    -> self
    #   生成指定大小的 Bitmap 对象。
    #
    def initialize(*args)
      #This is a stub, used for indexing
    end

    # dispose    -> nil
    #   释放位图，若位图已释放，则什么都不做。
    def dispose
      #This is a stub, used for indexing
    end

    # dispose?    -> nil
    #   释放位图，若位图已释放，则什么都不做。
    def dispose?
      #This is a stub, used for indexing
    end

    # width   -> Integer
    #   获取位图的宽度。
    def width
      #This is a stub, used for indexing
    end

    # height   -> Integer
    #   获取位图的高度。
    def height
      #This is a stub, used for indexing
    end

    # rect   -> Rect
    #   获取位图的矩形（Rect）。
    def rect
      #This is a stub, used for indexing
    end

    # blt(x, y, src_bitmap, src_rect[, opacity])   -> nil
    #   将位图 src_bitmap 的矩形 src_rect（Rect）中的数据整体传送到当前位图的坐标 (x, y) 处。
    #   opacity 是透明度，范围 0～255。
    def blt(x, y, src_bitmap, src_rect, opacity = 255)
      #This is a stub, used for indexing
    end

    # stretch_blt(dest_rect, src_bitmap, src_rect[, opacity])   -> nil
    #   将位图 src_bitmap 的矩形 src_rect（Rect）中的数据整体传送到当前位图的矩形 dest_rect（Rect）处。
    #   opacity 是透明度，范围 0～255。
    def stretch_blt(dest_rect, src_bitmap, src_rect, opacity = 255)
      #This is a stub, used for indexing
    end

    # fill_rect(x, y, width, height, color)   -> nil
    #   将位图的矩形 (x, y, width, height)填充指定的颜色 color（Color）。
    # fill_rect(rect, color)   -> nil
    #   将位图的矩形(rect)填充指定的颜色 color（Color）。
    def fill_rect(*args)
      #This is a stub, used for indexing
    end

    # gradient_fill_rect(x, y, width, height, color1, color2[, vertical])   -> nil
    #   将位图的矩形 (x, y, width, height)渐变填充颜色 color1（Color）至 color2（Color）。
    #   将 vertical 设为 true 可以纵向渐变。默认为横向渐变。
    # gradient_fill_rect(rect, color1, color2[, vertical])   -> nil
    #   将位图的矩形（Rect）渐变填充颜色 color1（Color）至 color2（Color）。
    #   将 vertical 设为 true 可以纵向渐变。默认为横向渐变。
    def gradient_fill_rect(*args)
      #This is a stub, used for indexing
    end

    # clear   -> nil
    #   清除整个位图。
    def clear
      #This is a stub, used for indexing
    end

    # clear_rect(x, y, width, height)   -> nil
    #   清除位图的矩形 (x, y, width, height)。
    # clear_rect(rect)   -> nil
    #   清除位图的矩形 rect（Rect）。
    def clear_rect(*args)
      #This is a stub, used for indexing
    end

    # get_pixel(x, y)   -> Color
    #   获取点 (x, y) 的颜色（Color）。
    def get_pixel(x, y)
      #This is a stub, used for indexing
    end

    # set_pixel(x, y, color)   -> color
    #   设置点 (x, y) 的颜色（Color）。
    def set_pixel(x, y, color)
      #This is a stub, used for indexing
    end

    # hue_change(hue)   -> nil
    #   在 360 度内变换位图的色相。
    #   此处理需要花费时间。另外，由于转换误差，反复转换可能会导致色彩失真。
    def hue_change(hue)
      #This is a stub, used for indexing
    end

    # blur   -> nil
    #   对位图执行模糊效果。此处理需要花费时间。
    def blur
      #This is a stub, used for indexing
    end

    # radial_blur(angle, division)    -> nil
    #   对位图执行放射型模糊。angle 指定 0~360 的角度，角度越大，效果越圆润。
    #   division 指定 2～100 的分界数，分界数越大，效果越平滑。此处理需要花费大量时间。
    def radial_blur(angle, division)
      #This is a stub, used for indexing
    end

    # draw_text(x, y, width, height, str[, align])    -> nil
    # draw_text(rect, str[, align])   -> nil
    #   在位图的矩形 (x, y, width, height) 或 rect（Rect）中描绘字符串 str 。
    #   若 str 不是字符串对象，则会在执行之前，先调用 to_s 方法转换成字符串。
    #   若文字长度超过区域的宽度，文字宽度会自动缩小到 60%。
    #   文字的横向对齐方式默认为居左，可以设置 align 为 1 居中，或设置为 2 居右。垂直方向总是居中对齐。
    #   此处理需要花费时间，因此不建议每帧重绘一次文字。
    def draw_text(*args)
      #This is a stub, used for indexing
    end

    # text_size(str)    -> Integer
    #   获取使用 draw_text 方法描绘字符串 str 时的矩形（Rect）。该区域不包含轮廓部分 (RGSS3) 和斜体的突出部分。
    #   若 str 不是字符串对象，则会在执行之前，先调用 to_s 方法转换成字符串。
    def text_size(str)
      #This is a stub, used for indexing
    end

  end

  # RGBA 颜色的类。每个成分以浮点数（Float）管理。
  # 超类：Object。
  #
  class Color

    # 红色值（0～255）。超出范围的数值会自动修正。
    attr_accessor :red

    # 绿色值（0～255）。超出范围的数值会自动修正。
    attr_accessor :green

    # 蓝色值（0～255）。超出范围的数值会自动修正。
    attr_accessor :blue

    # alpha 值（0～255）。超出范围的数值会自动修正。
    attr_accessor :alpha

    # Color.new(red, green, blue[, alpha])    -> self
    #   生成 Color 对象。alpha 值省略时使用 255。
    # Color.new   -> self
    #   如果没有指定参数，默认为(0, 0, 0, 0)。
    def Color.new(red = 0, green = 0, blue = 0, alpha = 0)
      #This is a stub, used for indexing
    end

    # set(red, green, blue[, alpha])  -> self
    #   一次设置所有属性。alpha默认值为255。
    # set(color)   -> self
    #   从另一个 Color 对象上复制所有的属性。(RGSS3)
    def set(*args)
      #This is a stub, used for indexing
    end

  end

  class Plane

  end

  # 矩形的类。
  # 超类：Object。
  #
  class Rect

    # 矩形左上角的 X 坐标。
    attr_accessor :x

    # 矩形左上角的 Y 坐标。
    attr_accessor :y

    # 矩形的宽度。
    attr_accessor :width

    # 矩形的高度。
    attr_accessor :height

    # Rect.new(x, y, width, height)
    #   创建一个 Rect 对象。未指定参数时，默认值为 (0, 0, 0, 0)。(RGSS3)
    def initialize(x = 0, y = 0, width = 0, height = 0)
      #This is a stub, used for indexing
    end

    # set(x, y, width, height)  -> self
    #   设置Rect的属性,一次设置所有属性。
    # set(rect)   -> self
    #   从另一个 Rect 对象上复制所有的属性。(RGSS3)
    def set(*args)
      #This is a stub, used for indexing
    end

    # empty   -> self
    #   将所有属性设置为 0。
    def empty
      #This is a stub, used for indexing
    end

  end

  class Sprite

  end

  class Table

  end

  class Tilemap

  end

  class Tone

  end

  class Viewport

  end

  class Window

  end

  class RGSSError

  end

  class RGSSReset

  end

  module Audio

  end

  module Graphics

  end

  module Input

  end

  def rgss_main(&block)

  end

  def rgss_stop

  end

  def load_data(filename)

  end

  def save_data(obj, filename)

  end

  def msgbox(*args)

  end

  def msgbox_p(*args)

  end

end