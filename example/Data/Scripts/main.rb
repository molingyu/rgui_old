#encoding: utf-8
#author: shitake
#data: 16-4-20
["/home/shitake/.rvm/gems/ruby-2.3.0@global/gems/did_you_mean-1.0.0/lib", "/home/shitake/.rvm/rubies/ruby-2.3.0/lib/ruby/site_ruby/2.3.0", "/home/shitake/.rvm/rubies/ruby-2.3.0/lib/ruby/site_ruby/2.3.0/x86_64-linux", "/home/shitake/.rvm/rubies/ruby-2.3.0/lib/ruby/site_ruby", "/home/shitake/.rvm/rubies/ruby-2.3.0/lib/ruby/vendor_ruby/2.3.0", "/home/shitake/.rvm/rubies/ruby-2.3.0/lib/ruby/vendor_ruby/2.3.0/x86_64-linux", "/home/shitake/.rvm/rubies/ruby-2.3.0/lib/ruby/vendor_ruby", "/home/shitake/.rvm/rubies/ruby-2.3.0/lib/ruby/2.3.0", "/home/shitake/.rvm/rubies/ruby-2.3.0/lib/ruby/2.3.0/x86_64-linux"].each{ |p| $LOAD_PATH << p }
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
  $g.debug if Input.press?(Input::F6)
end
