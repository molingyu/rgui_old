# CorePlus
所谓core_plus是对RM原版的RGSS3的一些增强，这些增强大体分为两类：一类是对已有类的增强，另一类则是新添加的类。

# List
* API
* Animation
* Bitmap
* Color
* Keyboard
* Mouse
* Numeric
* Rect
* Sprite
* String
* Timer

# API
## 模块方法
### to_api(str)
从形如``Dll名|函数名|参数|返回值|``的字符串创建Win32API对象。
### get_hwnd
返回RM的窗口句柄。
### get_rect
返回RM窗口在系统中的Rect区域。

# Animation
序图动画类。``Sprite``类的子类。提供序图动画的功能。父类是Sprite。
## 属性
### status \[R\]
当前序图动画对象的状态，只读。其值为0或1。正在播放时为1，其余为0。
### Bitmaps \[RW\]
序图动画的帧列表，为一个Bitmap数组。其顺序决定了序图播放时的顺序。
## 类方法
### new(bitmaps\[, viewport\])
生成一个Animation对象。必要时指定一个显示端口（Viewport）。
方法
``bitmaps``:帧动画的帧图像数组。
``viewport``:可选，Animation对象的显示端口。
## 实例方法
### play(x, y, frame_speed, fist_frame, end_frame[, reverse[, loop]])
从指定帧开始以指定帧速到结束帧播放帧动画。可反向播放，可指定循环。

``x``:帧动画的显示位置的x坐标。

``y``:帧动画的显示位置的y坐标。

``frame_speed``:帧动画的播放速度，值为大于0的整数。数值越大速度越慢。

``start_frame``:起始帧的序号，第一帧从0开始计数。

``end_frame``:结束帧的序号。

``reverse``:是否反向播放，默认为false，若为true，则从结束帧往起始帧播放。

``loop``:是否开启循环，默认为false，若为true，则会循环播放，知道重新播放或被释放。
### frame
获取当前帧的Bitmap对象。
### update
更新，原则上每帧调用一次。
### dispose
释放掉Animation对象。原理等同于Sprite的dispose方法，只不过会将整个bitmaps都释放掉。

# Bitmap
## 实例方法
### cut_bitmap(width, height, type)
图片分割，将图片切割成指定大小并返回一个Bitmap数组。切割方式取决于type参数。

``width``:分割后新图片的宽度。

``height``:分割后新图片的高度。

``type``:分割方式。0按行分割；1按列分割；2先按行分割，再按列分割；3先按列分割，再按行分割。

### cut_bitmap_conf(config)
图片分割，将图片按参数数组所指定的大小进行分割并返回一个Bitmap数组。不同于cut_bitmap的是，分割后的图片大小并不一定相等

``config``:分割图片时用到的参数。其值为一个形如``[..., [x, y, width, height], ...]``的记录每个分割后图片位置的二重嵌套数组。

### scale9bitmap(a, b, c, d, width, height)
以九宫格形式返回指定大小的新的Bitmap对象。
参数说明:
![scale9](./res/scale6.png)

### draw_line(x1, y1, x2, y2, color)
在Bitmap对象的指定位置画线。

``x1``:起点x坐标。

``y1``:起点y坐标。

``x2``:终点x坐标。

``y2``:终点y坐标。

``color``:线条颜色(为Color对象)。

### save_png(filename)
将Bitmap对象保存为png。

``filename``:保存文件的地址。

# Color
## 常量
### 十二基本色
|名称|说明|值|示例|
| --------  | ------|------|-------------|
|RED| 红色|rgb(255, 0 ,0)|![img](./res/core_plus_color_red.png)|
|ORANGE| 橙色|rgba(255, 165, 0, 255)|![img](./res/core_plus_color_orange.png)|
|YELLOW|黄|rgba(255, 255, 0, 255)|![img](./res/core_plus_color_yellow.png)|
|GREEN|绿|rgba(0, 255, 0, 255)|![img](./res/core_plus_color_green.png)|
|CHING|青|rgba(0, 255, 255, 255)|![img](./res/core_plus_color_ching.png)|
|BLUE|蓝|rgba(0, 0, 255, 255)|![img](./res/core_plus_color_blue.png)|
|PURPLE|紫|rgba(139, 0, 255, 255)|![img](./res/core_plus_color_purple.png)|
|BLACK|黑|rgba(0, 0, 0, 255)|![img](./res/core_plus_color_black.png)|
|WHITE|白|rgba(255, 255, 255, 255)|![img](./res/core_plus_color_white.png)|
|GREY|灰|rgba(100, 100, 100, 255)|![img](./res/core_plus_color_grey.png)|

### 十二色环
|名称|值|示例|
| --------  | ------------|-------------|
|CR1|rgba(230, 3, 18, 255)|![img](./res/core_plus_color_cr1.png)|
|CR2|rgba(233, 65, 3, 255)|![img](./res/core_plus_color_cr2.png)|
|CR3|rgba(240, 126, 15, 255)|![img](./res/core_plus_color_cr3.png)|
|CR4|rgba(240, 186, 26, 255)|![img](./res/core_plus_color_cr4.png)|
|CR5|rgba(234, 246, 42, 255)|![img](./res/core_plus_color_cr5.png)|
|CR6|rgba(183, 241, 19, 255)|![img](./res/core_plus_color_cr6.png)|
|CR7|rgba(122, 237, 0, 255)|![img](./res/core_plus_color_cr7.png)|
|CR8|rgba(62, 234, 2, 255)|![img](./res/core_plus_color_cr8.png)|
|CR9|rgba(50, 198, 18, 255)|![img](./res/core_plus_color_cr9.png)|
|CR10|rgba(51, 202, 73, 255)|![img](./res/core_plus_color_cr10.png)|
|CR11|rgba(56, 203, 135, 255)|![img](./res/core_plus_color_cr11.png)|
|CR12|rgba(60, 194, 197, 255)|![img](./res/core_plus_color_cr12.png)|

### 三十二灰阶
|名称|值|示例|
| --------  | ------------|---------|
|GL1|rgba(0, 0, 0, 255)|![img](./res/core_plus_color_gl1.png)|
|GL2|rgba(8, 8, 8, 255)|![img](./res/core_plus_color_gl2.png)|
|GL3|rgba(16, 16, 16, 255)|![img](./res/core_plus_color_gl3.png)|
|GL4|rgba(24, 24, 24, 255)|![img](./res/core_plus_color_gl4.png)|
|GL5|rgba(32, 32, 32, 255)|![img](./res/core_plus_color_gl5.png)|
|GL6|rgba(40, 40, 40, 255)|![img](./res/core_plus_color_gl6.png)|
|GL7|rgba(48, 48, 48, 255)|![img](./res/core_plus_color_gl7.png)|
|GL8|rgba(56, 56, 56, 255)|![img](./res/core_plus_color_gl8.png)|
|GL9|rgba(64, 64, 64, 255)|![img](./res/core_plus_color_gl9.png)|
|GL10|rgba(72, 72, 72, 255)|![img](./res/core_plus_color_gl10.png)|
|GL11|rgba(80, 80, 80, 255)|![img](./res/core_plus_color_gl11.png)|
|GL12|rgba(88, 88, 88, 255)|![img](./res/core_plus_color_gl12.png)|
|GL13|rgba(96, 96, 96, 255)|![img](./res/core_plus_color_gl13.png)|
|GL14|rgba(104, 104, 104, 255)|![img](./res/core_plus_color_gl14.png)|
|GL15|rgba(112, 112, 112, 255)|![img](./res/core_plus_color_gl15.png)|
|GL16|rgba(120, 120, 120, 255)|![img](./res/core_plus_color_gl16.png)|
|GL17|rgba(128, 128, 128, 255)|![img](./res/core_plus_color_gl17.png)|
|GL18|rgba(136, 136, 136, 255)|![img](./res/core_plus_color_gl18.png)|
|GL19|rgba(144, 144, 144, 255)|![img](./res/core_plus_color_gl19.png)|
|GL20|rgba(152, 152, 152, 255)|![img](./res/core_plus_color_gl20.png)|
|GL21|rgba(160, 160, 160, 255)|![img](./res/core_plus_color_gl21.png)|
|GL22|rgba(168, 168, 168, 255)|![img](./res/core_plus_color_gl22.png)|
|GL23|rgba(176, 176, 176, 255)|![img](./res/core_plus_color_gl23.png)|
|GL24|rgba(184, 184, 184, 255)|![img](./res/core_plus_color_gl24.png)|
|GL25|rgba(192, 192, 192, 255)|![img](./res/core_plus_color_gl25.png)|
|GL26|rgba(200, 200, 200, 255)|![img](./res/core_plus_color_gl26.png)|
|GL27|rgba(208, 208, 208, 255)|![img](./res/core_plus_color_gl27.png)|
|GL28|rgba(216, 216, 216, 255)|![img](./res/core_plus_color_gl28.png)|
|GL29|rgba(224, 224, 224, 255)|![img](./res/core_plus_color_gl29.png)|
|GL30|rgba(232, 232, 232, 255)|![img](./res/core_plus_color_gl30.png)|
|GL31|rgba(240, 240, 240, 255)|![img](./res/core_plus_color_gl31.png)|
|GL32|rgba(248, 248, 248, 255)|![img](./res/core_plus_color_gl32.png)|

## 类方法
### str2color(str)
将一个形如'rgba(xx, xx, xx, xx)'的字符串转换为一个Color对象。

``str``:欲转换的字符串。
### hex2color(hex)
从十六进制颜色码创建Color对象。

``hex``:欲转换的十六进制颜色码(为字符串)。
## 实例方法
### inverse
取该颜色的反色。
### to_rgba
以``rgba(xx, xx, xx, xx, xx)``的形式输出该颜色值。
### to_hex
输出该对象所对应的十六进制颜色码，忽略alpha值。

# Keyboard
键盘输入模块。
## 模块方法
### init
初始化该模块，无需手动调用。
### update
每帧更新，已在Input#update内调用，无需手动调用。
### press?(key_name)
键按住，当键处于按住状态时，返回true。

``key_name``:欲判断的键名，可为String或Symbol。
### down?(key_name)
键按下，当键按下的瞬间时，返回true。

``key_name``:欲判断的键名，可为String或Symbol。
### up?(key_name)
键弹起，当键弹起的瞬间时，返回true。

``key_name``:欲判断的键名，可为String或Symbol。
## 关于``key_name``
|key_name|对应按键|
|--------------|-----------|
|MOUSE_LB|鼠标左键|
|MOUSE_RB|鼠标右键|
|MOUSE_MB|鼠标中键|
|KEY_BACK|Back键|
|KEY_TAB|Tab键|
|KEY_CLEAR|Ctrl键|
|KEY_ENTER|回车键|
|KEY_SHIFT|Shift键|
|KEY_CTRL|Ctrl键|
|KEY_ALT|Alt键|
|KEY_PAUSE|Pause Break键|
|KEY_CAPITAL|Caps Lock键|
|KEY_ESC|Esc键|
|KEY_SPACE|Space键|
|KEY_PRIOR|Page Up键|
|KEY_NEXT|Page Down键|
|KEY_END| |
|KEY_HOME|Home键|
|KEY_LEFT|Left Arrow键|
|KEY_UP|Up Arrow键|
|KEY_RIGHT|Right Arrow键|
|KEY_DOWN|Down Arrow键|
|KEY_SELECT| |
|KEY_EXECUTE| |
|KEY_INS|Ins键 |
|KEY_DEL|Del键 |
|KEY_HELP| |
|KEY_0|0键|
|KEY_1|1键 |
|KEY_2| 2键|
|KEY_3| 3键|
|KEY_4| 4键|
|KEY_5| 5键|
|KEY_6| 6键|
|KEY_7| 7键|
|KEY_8| 8键|
|KEY_9| 9键|
|KEY_A|A键 |
|KEY_B| B键|
|KEY_C| C键|
|KEY_D| D键|
|KEY_E|E键 |
|KEY_F| F键|
|KEY_G|G键 |
|KEY_H| H键|
|KEY_I| I键|
|KEY_J| J键|
|KEY_K| K键|
|KEY_L| L键|
|KEY_M| M键|
|KEY_N| N键|
|KEY_O| O键|
|KEY_P| P键|
|KEY_Q| Q键|
|KEY_R| R键|
|KEY_S| S键|
|KEY_T| T键|
|KEY_U| U键|
|KEY_V| V键|
|KEY_W| W键|
|KEY_X| X键|
|KEY_Y| Y键|
|KEY_Z| Z键|
|KEY_NUM_0|小键盘0键 |
|KEY_NUM_1|小键盘1键 |
|KEY_NUM_2|小键盘2键 |
|KEY_NUM_3| 小键盘3键|
|KEY_NUM_4| 小键盘4键|
|KEY_NUM_5|小键盘5键 |
|KEY_NUM_6|小键盘6键 |
|KEY_NUM_7|小键盘7键 |
|KEY_NUM_8|小键盘8键 |
|KEY_NUM_9|小键盘9键 |
|KEY_NULTIPLY|小键盘\*键|
|KEY_ADD|小键盘+键 |
|KEY_SEPARATOR|##小键盘 键 |
|KEY_SUBTRACT|小键盘-键 |
|KEY_DECIMAL|小键盘.键 |
|KEY_DIVIDE|小键盘/键 |
|KEY_F1| F1键|
|KEY_F2| F3键|
|KEY_F3| F3键|
|KEY_F4| F4键|
|KEY_F5| F5键|
|KEY_F6| F6键|
|KEY_F7| F7键|
|KEY_F8| F8键|
|KEY_F9| F9键|
|KEY_F10|F10键 |
|KEY_F11|F11键 |
|KEY_F12|F12键 |
|KEY_NUMLOCK|Num Lock键|
|KEY_SCROLL|Scroll Lock键 |


# Mouse
鼠标模块。
## 模块方法
### get_global_pos
获取鼠标当前相对于操作系统的坐标，返回值为一个``[x, y]``这样的数组。

### get_pos
获取鼠标当前相对于RGSS Player窗体的坐标，返回值为一个``[x, y]``这样的数组，窗体之外一律为\[-1, -1\]。

# Numeric
## 实例方法
### fpart
获取该数的小数部分。
### rfpart
获取该数的1 - 小数部分。

# Rect
## 类方法
### array2rect(array)
将一个形如``[x, y, width, height]``的数组转换为一个Rect对象。

``array``:欲转换的数组。
## 实例方法
### rect2array
将一个rect对象转换为形如[x, y, width, height]形式的数组。
### point_hit(x, y)
判断点是否在rect内，若在则返回true，否则false。

``x``:欲检测点的x坐标。

``y``:欲检测点的y坐标。
### rect_hit(rect)
判断两个rect是否相交，若相交则返回true，否则false。

``rect``:欲判断的另一个rect对象。

# String
## 实例方法
### u2s
将字符串编码从utf-8转换为系统编码，返回新字符串。
### u2s!
将字符串编码从utf-8转换为系统编码。
### s2u
将字符串编码从系统编码转换为utf-8。返回新字符串。
### s2u!
将字符串编码从系统编码转换为utf-8。
### to_api
效果等同于API#to_api。此时转换的字符串为其自身。

# Timer
## 类方法
### new
返回一个新的计时器对象。
### update
更新所有存在的计时器对象。
## 属性
### status
返回当前计时器的状态，值为``:run``、``:stop``其中一个。
## 实例方法
### start
开始计时器对象。
### stop
暂停计时器对象。
### after(time){ ... }
等待指定秒数后执行。此方法会生成并返回一个TimerEvent对象。

``time``:等待的秒数。

``block``:执行的动作。
### every(time){ ... }
每隔指定秒数后执行。此方法会生成并返回一个TimerEvent对象。

``time``:等待的秒数。

``block``:执行的动作。
### delete_after(object)
从计时器after_event列表里删除指定的TimerEvent对象。
``object``:欲删除的对象。
### delete_every(object)
从计时器every_event列表里删除指定的TimerEvent对象。

``object``:欲删除的对象。
### dispose
释放计时器对象。
### update
更新计时器对象，原则上不需要手动调用。
