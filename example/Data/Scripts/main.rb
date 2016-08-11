#encoding: utf-8
#author: shitake
#data: 16-4-20

require  'Data/Scripts/game.rb'

$g = Game.new

$g.load_libs
$g.load_games
$g.load_views


32.times{|i|
  name = "GL#{i+1}"
  bitmap = Bitmap.new(40, 16)
  color = eval("Color::#{name}")
  bitmap.fill_rect(bitmap.rect, color)
  bitmap.save_png("../doc/res/core_plus_color_#{name.downcase}.png")
  print "|#{name}|#{color.to_rgba}|![img](./res/core_plus_color_#{name.downcase}.png)|\n"
}
  exit


$g.init('test', 640, 480) do
  RGUI.PATH = '../src'
  RGUI.init
  $g.exit = false
  $g.start_view = TitleView
end

until $g.exit
  $g.update
end
