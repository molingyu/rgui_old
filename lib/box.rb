#encoding: utf-8
#author: shitake
#data: 16-9-26

class Range
  # 判断两个范围是否相交。
  def intersects(range)
    !(self.last < range.first || self.first > range.last)
  end
end

module Math
  def self.a2r(angle)
    angle * Math::PI / 180 if angle.kind_of? Numeric
  end
end

# 表示二维坐标系上点的对象
class Point

  attr_accessor :x
  attr_accessor :y

  def initialize(x = 0, y = x)
    @x = x.to_i
    @y = y.to_i
  end

  # 二维坐标下两点距离
  def distance(point)
    Math.hypot(@x - point.x, @y - point.y)
  end

  # 二维坐标下两点解析距离
  def distance_axis(point)
    [point.x - @x,point.y - @y]
  end

  def set(x = 0, y = x)
    @x = x
    @y = y
  end

end

class Vector2

  attr_accessor :x
  attr_accessor :y

  def initialize(x, y)
    @x = x || 0
    @y = y || 0
  end

  #点乘
  def dot(vector2 = self)
    @x * vector2.x + @y * vector2.y
  end

  #叉乘
  def cross(vector2 = self)
    @x * vector2.y - vector2.x * @y
  end

  #模
  def module
    Math.hypot(@x, @y)
  end

  def +(vector2)
    raise StandardError if vector2.class != Vector2
    Vector2.new(vector2.x + @x, vector2.y + @y)
  end

  def -(vector2)
    raise StandardError if vector2.class != Vector2
    Vector2.new(@x - vector2.x, @y - vector2.y)
  end

  def abs
    Vector2.new(@x.abs, @y.abs)
  end

  def max(value)
    Vector2.new((@x > value ? @x : value), (@y > value ? @y : value))
  end

  def min(value)
    Vector2.new((@x < value ? @x : value), (@y < value ? @y : value))
  end

end

class Axes

  attr_accessor :origin
  attr_accessor :radian
  attr_reader :x
  attr_reader :y

  #origin:原点，radian:偏转弧度
  def initialize(origin, radian)
    @origin = origin
    @radian = radian
    set_axes(@radian)
  end

  def radian=(value)
    return if @radian == value
    @radian = value
    set_axes(value)
  end

  def set_axes(radian)
    @x = Vector2.new(Math.cos(radian), Math.sin(radian))
    @y = Vector2.new(-1 * Math.sin(radian), Math.cos(radian))
  end

  #返回逆坐标系
  def a_axes
    Axes.new(Point.new(- @origin.x, - @origin.y), -radian)
  end

  #返回向量在当前坐标系下的投影
  def shadow(vector2)
    x = vector2.dot(@x)
    y = vector2.dot(@y)
    Vector2.new(x, y)
  end

  #返回点在当前坐标系下的坐标
  def point(point)
    vector2 = shadow(Vector2.new(point.x - @origin.x, point.y - @origin.y))
    Point.new(vector2.x, vector2.y)
  end

end

class AABB

  attr_reader :x
  attr_reader :y
  attr_reader :width
  attr_reader :height
  attr_reader :center
  attr_reader :width_range
  attr_reader :height_range

  def initialize(x = 0, y = 0, width = 0, height = 0)
    @x = x
    @y = y
    @width = width
    @height = height
    create
  end

  def create
    @width_range = Range.new(@x, @x + @width)
    @height_range = Range.new(@y, @y + @height)
    @center = Point.new(@x + @width / 2, @y + @height / 2)
  end

  def points
    [
        Point.new(@x, @y), #左上
        Point.new(@x + @width, @y), #右上
        Point.new(@x, @y + @height), #左下
        Point.new(@x + @width, @y + @height) #右下
    ]
  end

  def x=(value)
    return if @x == value
    @x = value
    create
  end

  def y=(value)
    return if @y == value
    @y = value
    create
  end

  def width=(value)
    return if @width == value
    @width = value
    create
  end

  def height=(value)
    return if @height == value
    @height = value
    create
  end

  def collision(obj)
    method_name = (obj.class.to_s.downcase + '_collision').to_sym
    self.send(method_name, obj)
  end

  # point 相交测试
  def point_collision(point)
    @width_range.eql?(point.x) && @height_range.eql?(point.y)
  end

  # aabb 相交测试
  def aabb_collision(aabb)
    @width_range.intersects(aabb.width_range) && @height_range.intersects(aabb.height_range)
  end

  # obb 相交测试
  def obb_collision(obb)
    return aabb_collision(obb.obb2aabb) if obb.angle % 90 == 0
    obb.obb_collision(aabb2obb)
  end

  # sphere 相交测试
  def sphere_collision(sphere)
    sphere.aabb_collision(self)
  end

  def aabb2obb
    OBB.new(@center.x, @center.y, @width, @height, 0)
  end

  def aabb2sphere
    radius = Math.sqrt((@width / 2) ** 2 + (@height / 2) ** 2).ceil
    Sphere.new(@x, @y, radius)
  end

end

class OBB

  attr_reader :x
  attr_reader :y
  attr_reader :center
  attr_reader :width
  attr_reader :height
  attr_reader :angle
  attr_reader :width_range
  attr_reader :height_range
  attr_reader :center
  attr_reader :axes

  def initialize(x, y, width = 0, height = 0, angle)
    @x = x
    @y = y
    @width = width
    @height = height
    value = angle % 360
    @angle = value > 180 ? value - 180 : value
    create
  end



  def create
    @center = Point.new(@x, @y)
    @axes = Axes.new(@center, Math.a2r(@angle))
    @width_range = Range.new(-@width / 2, @width / 2)
    @height_range = Range.new(-@height / 2, @height / 2)
  end

  def x=(value)
    return if @x == value
    @x = value
    create
  end

  def y=(value)
    return if @y == value
    @y = value
    create
  end

  def width=(value)
    return if @width == value
    @width = value
    create
  end

  def height=(value)
    return if @height == value
    @height = value
    create
  end

  def angle=(value)
    value = value % 360
    return if @angle == (value > 180 ? value - 180 : value)
    @angle = value
    create
  end

  # ERROR
  # def points
  #   axes = Axes.new(Point.new(-@x, -@y), Math.a2r(-@angle))
  #   [
  #       axes.point(Point.new(@width / 2, @height / 2)),
  #       axes.point(Point.new(- @width / 2, @height / 2)),
  #       axes.point(Point.new(- @width / 2, - @height / 2)),
  #       axes.point(Point.new(@width / 2, - @height / 2)),
  #   ]
  # end

  def collision(obj)
    method_name = (obj.class.to_s.downcase + '_collision').to_sym
    self.send(method_name, obj)
  end

  # point 相交测试
  def point_collision(point)
    point = @axes.point(point)
    width_range.eql?(point.x) && height_range.eql?(point.y)
  end

  # aabb 相交测试
  def aabb_collision(aabb)
    aabb.obb_collision(self)
  end

  # obb 相交测试，轴向分离法
  def obb_collision(obb)
    obb_in_this_center = axes.point(obb.center)
    this_in_obb_center = obb.axes.point(@center)
    ow_range = Range.new(obb_in_this_center.x - obb.width / 2, obb_in_this_center.x + obb.width / 2)
    oh_range = Range.new(obb_in_this_center.y - obb.height / 2, obb_in_this_center.y + obb.height / 2)
    w_o_range = Range.new(this_in_obb_center.x - @width / 2, this_in_obb_center.x + @width / 2)
    h_o_range = Range.new(obb_in_this_center.y - @height / 2, obb_in_this_center.y + @height / 2)
    width_range.intersects(ow_range) && height_range.intersects(oh_range) && obb.width_range.intersects(w_o_range) && obb.height_range.intersects(h_o_range)
  end

  def sphere_collision(sphere)
    sphere.obb_collision(self)
  end

  def obb2aabb
    return AABB.new(@x - @width / 2, @y - @height / 2, @width, @height) if @angle == 0
    return AABB.new(@x - @height / 2, @y - @width / 2, @height, @width) if @angle == 90 || @angle == 180
    # ERROR
    AABB.new(points.min_by(&:x).x, points.min_by(&:y).y, points.max_by(&:x).x, points.max_by(&:y).y)
  end

  def obb2sphere
    radius = Math.sqrt((@width / 2) ** 2 + (@height / 2) ** 2).ceil
    Sphere.new(@x, @y, radius)
  end

end

class Sphere

  attr_reader :x
  attr_reader :y
  attr_reader :radius
  attr_reader :center
  attr_reader :width_range
  attr_reader :height_range

  def initialize(x, y, radius)
    @x = x
    @y = y
    @radius = radius
    create
  end

  def width
    @radius * 2
  end

  alias :height :width

  def x=(value)
    return if @x == value
    @x = value
    create
  end

  def y=(value)
    return if @y == value
    @y = value
    create
  end

  def radius=(value)
    return if @radius == value
    @radius = value
    create
  end

  def create
    @center = Point.new(@x, @y)
    @width_range = Range.new(@x - @radius, @x + @radius)
    @height_range = Range.new(@y - @radius, @y + @radius)
  end

  def collision(obj)
    method_name = (obj.class.to_s.downcase + '_collision').to_sym
    self.send(method_name, obj)
  end

  def point_collision(point)
    (point.x - @x) ** 2 + (point.y - @y) ** 2 <= @radius ** 2
  end

  def sphere_collision(sphere)
    point_collision(sphere.point)
  end

  def aabb_collision(aabb)
    # http://www.zhihu.com/question/24251545/answer/27184960
    sphere_center2rect_center = (Vector2.new(@x, @y) - Vector2.new(aabb.center.x, aabb.center.y)).abs
    rect_half_length = (Vector2.new(aabb.points[1].x, aabb.points[1].y.abs) - Vector2.new(aabb.center.x, aabb.center.y)).abs
    sphere_center2rect = (sphere_center2rect_center - rect_half_length).max(0)
    sphere_center2rect.dot <= @radius * @radius
  end

  def obb_collision(obb)
    point = obb.axes.point(@center)
    sphere_center2rect_center = (Vector2.new(point.x, point.y) - Vector2.new(0, 0)).abs
    rect_half_length = Vector2.new(obb.width / 2, obb.height / 2)
    sphere_center2rect = (sphere_center2rect_center - rect_half_length).max(0)
    sphere_center2rect.dot <= @radius * @radius
  end

  def sphere2aabb
    AABB.new(@x - @radius, @y - @radius, @radius * 2, @radius * 2)
  end

  def sphere2obb
    sphere2aabb.aabb2obb
  end

end