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
    @actor.play(32, 32, 20, 0, 2, false, true)
    @text_box = TextBox.new
    @text_box.set_pos(24,24)
    @txt = ''
  end
  
  def update
    super
    @actor.update
    @sprite.update
    @text_box.update
    @txt = @text_box.text if @txt != @text_box and @txt != ''
  end

end
