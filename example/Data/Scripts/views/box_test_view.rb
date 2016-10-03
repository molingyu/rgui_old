#encoding: utf-8
#author: shitake
#data: 16-4-20
require_relative  '../../../../lib/box'
require 'pp'
class BoxTestView < View

  class Box
    attr_reader :box
    attr_reader :box_sprite
    def initialize(box, color)
      @box_sprite = Sprite.new
      @box = box
      @box_sprite.bitmap = Bitmap.new(@box.width, @box.height)
      @box_sprite.bitmap.fill_rect(0, 0, @box.width, @box.height, color)
      if box.class == AABB
        @box_sprite.x, @box_sprite.y = @box.x , @box.y
      elsif box.class == OBB

        @box_sprite.ox = @box.width / 2
        @box_sprite.oy = @box.height / 2
        @box_sprite.angle = @box.angle
        @box_sprite.x = @box.x
        @box_sprite.y = @box.y
      elsif box.class == Sphere
        @box_sprite.ox = @box_sprite.oy = @box.radius
        @box_sprite.x = @box.x
        @box_sprite.y = @box.y
      end
    end

    def move(x, y)
      @box_sprite.x = @box.x = x
      @box_sprite.y = @box.y = y
    end

  end

  def initialize
    super
    @bg = Sprite.new
    @bg.bitmap = Bitmap.new(Graphics.width, Graphics.height)
    @bg.bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, Color::GL9)
    Graphics.width.times{|i| @bg.bitmap.fill_rect(i, 0, 1, Graphics.height, Color::WHITE) if i % 10 == 0 }
    Graphics.height.times{|i| @bg.bitmap.fill_rect(0, i, Graphics.width, 1, Color::WHITE) if i % 10 == 0 }
    @bg.opacity = 200
    @box = []
    @test = Box.new(AABB.new(12, 12, 32, 32), Color::BLUE)
    @box.push @aabb = Box.new(AABB.new(234, 122, 32, 56), Color::ORANGE)
    # @box.push @obb = Box.new(OBB.new(200, 300, 40, 100, 30), Color::ORANGE)
    @box.push @sphere = Box.new(Sphere.new(100, 100, 50), Color::ORANGE)
    @index = 0
  end

  def update
    super
    @test.move *Mouse.get_pos
    @box.each do |box|
      if @test.box.collision(box.box)
        box.box_sprite.color = Color::WHITE
      else
        box.box_sprite.color = Color::ORANGE
      end
    end
    # @obb.box_sprite.angle += 1
    # @obb.box.angle += 1
  end

end