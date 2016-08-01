# RGUI是什么
RGU是RPG Maker GUI的缩写，是为便捷RM的GUI开发而编写成的基于RGSS的可复用代码集。其有着灵活的事件系统（基于Fiber），提供GUI控件的动画接口，支持skin。暂时只有RGSS3版。
RGUI通过Base类定义了UI控件的公共属性和方法，以及控件的整个生命周期内的流程。EventManger类则定义了RGUI的事件系统。Skin类则负责皮肤的加载。并通过对Input的重定义，支持鼠标、全键盘以及输入法。

# RGUI的模块方法和变量
## 变量
| 项目       |  数量                     |
| --------  | -------------------------|
|MOUSE?　　　|是否启动鼠标支持，默认为true。|
|KEYBOARD?　|是否启动键盘支持，默认为true。|
|CONTROLS   |控件数，通过``auto_load``方法自动统计载入的GUI控件数 |
|PATH       |整个GUI代码所在位置（可以为相对位置），用于``auto_load``方法。|
|SKIN_PATH  |皮肤文件所在位置，用于``Skin``模块载入皮肤。|

## 模块方法
### get_id

### hit(x, y, rect)

### border

# RGUI::Base RGUI的控件的核心

