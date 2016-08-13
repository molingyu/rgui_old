#encoding: utf-8
#author: shitake
#data: 16-4-20

require  'Data/Scripts/game.rb'

$g = Game.new

$g.load_libs
$g.load_games
$g.load_views

$g.init('test', 640, 480) do
  RGUI.PATH = '../src'
  RGUI.init
  $g.exit = false
  $g.start_view = TitleView
end

until $g.exit
  $g.update
end
