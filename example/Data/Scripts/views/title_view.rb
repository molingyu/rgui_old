#encoding: utf-8
#author: shitake
#data: 16-4-20

class TitleView < View

  def initialize
    super
    bitmap = $g.load_image('Pictures/box_1.png')
    @sprite = Sprite.new
    @sprite.bitmap = bitmap.scale9bitmap(20, 20, 20, 20, 256, 300)
    actors = $g.load_image('Characters/actor.png').cut_row_rank(96, 128)
    @actor = Animation.new(actors[0].cut_rank_row(32,32))
    @actor.play(32, 32, 60, 0, 2, false, true)
    @pos = [0, 0]
    @mouse_pos = Sprite.new
    @mouse_pos.bitmap = Bitmap.new(544, 416)
    @mouse_pos.x, @mouse_pos.y = 1, 1
    Keyboard.init
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
      @mouse_pos.bitmap.draw_text(10, 0, 100, 24, "x:#{pos[0]}y:#{pos[1]}")
      @pos = pos
    end
    p "down" if Keyboard.trigger?(:KEY_SPACE)
    p "hold" if Keyboard.press?(:KEY_SPACE)
    p "up" if Keyboard.up?(:KEY_SPACE)
  end

end
