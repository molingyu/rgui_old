#encoding: utf-8
#author: shitake
#data: 16-4-20

class TitleView < View

  def initialize
    super
    bitmap = $g.load_image('Pictures/box_1.png')
    p bitmap.blt(0, 0, Bitmap.new(12, 12), Rect.new(0, 0, 12, 12), 255)
    @sprite = Sprite.new
    @sprite.bitmap = bitmap.scale9bitmap(20, 20, 20, 20, 256, 300)
    actors = $g.load_image('Characters/actor.png').cut_row_rank(96, 128)
    list = actors[0].cut_rank_row(32,32)
    @actor = Animation.new([list[3], list[4], list[5], list[4]])
    @actor.play(32, 32, 6, 0, 3, false, true)
    @pos = [0, 0]
    @mouse_pos = Sprite.new
    @mouse_pos.bitmap = Bitmap.new(544, 416)
    @mouse_pos.x, @mouse_pos.y = 1, 1

  end
  
  def update
    super
    @actor.update
    @sprite.update
    mouse_pos
  end

  def mouse_pos
    pos = Mouse.get_pos
    if pos != @pos
      @mouse_pos.bitmap.clear
      @mouse_pos.bitmap.draw_text(10, 0, 400, 24, sprintf("x:%03d y:%03d", pos[0], pos[1]))
      @pos = pos
    end
  end

end
