# Event
利用Fiber的可异步事件系统。用来解决复杂的事件产生与触发（诸如GUI的事件处理等）。

## Event::EventManger

## Event::EventCallbackFiber
该类是当某个event被``EventManger#trigger``方法触发时，用于包裹对应事件的回调函数的类。其作用是给回调函数套上一层Fiber的壳。此类用于EventManger内部。

### 属性
#### name \[R\]
事件名，只读。

#### info \[R\]
事件被触发时所包含的信息(调用EventManger#trigger方法时传入的info参数)，只读。

#### callback \[R\]
回调函数，只读。

### 实例方法
#### new(name, callback, info)
创建一个EventCallbackFiber的实例对象。
``name``:事件名。
``callback``:欲包裹的事件回调，为一个block对象。
``info``:事件被触发时所包含的信息。

#### resume
事件挂起后，调用此方法返回到挂起前的地方。等同于``Fiber#resume``。

#### alive？
判断该对象对应的Fiber实例是否存活，若存活返回true。

## Event::Event
此类用于EventManger内部。

### 属性
#### name \[R\]
事件名，只读。

#### type \[R\]
事件类型，只读。

### 实例方法
#### new(name, type)
创建一个event对象实例。
``name``:事件名。
``type``:事件类型。

#### length
返回该事件的回调函数数组大小。效果可参考``Array#length``。

#### push
添加一个回调函数。效果可参考``Array#push``。

#### each{|callback| ... }
遍历整个事件的回调函数数组。效果可参考``Array#each``。

#### []=(index, value)
修改回调函数列表指定位置的值。效果可参考``Array#[]=``。
``index``:欲修改元素的位置。
``value``:新的值。

#### delete(value)
删除回调函数数组指定成员。效果可参考``Array#delete``。
``value``:欲删除的对象。

#### clear
清除整个回调函数数组。效果可参考``Array#clear``。