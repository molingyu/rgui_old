# Event
利用Fiber的可异步事件系统。用来解决复杂的事件产生与触发（诸如GUI的事件处理等）。

## Event::EventManger
### 属性
#### events \[RW\]
已绑定的事件列表。
#### this \[RW\]
用于事件回调Proc中。this会在调用对应的`EventCallbackFiber#resume`时绑定当前事件回调Proc对象本身，并在调用结束后解除绑定(值变为nil)。具体可查看`EventManger#update`。
```ruby
def update
  if @event_fibers != []
    @event_fibers.each do |o|
      next @event_fibers.delete(o) unless o.alive?
      $event = self
      $event.this = o
      o.resume
      $event.this = nil
    end
    $event = nil
  end
end
```
#### timer \[RW\]
事件回调的计时器数组，多配合`EventManger#wait`使用。
#### counter \[RW\]
事件回调的计次器数组，多配合`EventManger#times`使用。
#### timer_filter \[RW\]
事件回调的filter计时器数组，多配合`EventManger#wait_filter`使用。
#### counter_filter \[RW\]
事件回调的filter计次器数组，多配合`EventManger#times_filter`使用。
### 类方法
#### new
生成一个EventManger对象的实例。
### 实例方法
#### update
更新。原则上每帧调用一次。
#### trigger(name *\[, info\]*)
触发指定事件。
`name`:被触发的事件名。类型为String或Symbol。
`info`:可选，触发事件是同时传递过去的额外信息。
#### on(name *\[, type\[, index\]\]*){|event_manger, info| ... }
为指定事件添加一个回调。回调中可以有event_manger和info两个参数，event_manger参数为其所对应的EventManger，info参数的值为`EventManger#trigger`方法被调用时所传入的info参数。
`name`:欲添加的事件名。
`type`:其对应的事件的事件类型。只有在首次添加是才会起作用。
```ruby
def on(name, type = nil, index = nil, &callback)
  #其他代码
  @events[name] = @events[name] || Event.new(name, type)
  #其他代码
end
```
`index`:可选，添加的事件回调在`eventManger#events`里的位置。默认会添加在`eventManger#events`末尾。
`block`:回调函数。
#### delete
将此回调从回调列表中删除。
#### ok?{ ... }
直到区块返回true时，再执行其后的代码。
#### filter{ ... }
只有在区块返回true时，才执行其后的代码，其余触发会被忽略。
#### wait(value)
等待指定时间(单位为秒)后再执行其后的代码。
#### times(value)
等待指定触发次数后再执行其后的代码。
#### wait_filter(value)
在指定时间间隔内，只执行一次其后的代码，其余触发会被忽略。
#### times_filter(value)
在指定触发次数间隔内，只执行一次其后的代码，其余触发会被忽略。

## Event::EventCallbackFiber
该类是当某个event被`EventManger#trigger`方法触发时，用于包裹对应事件的回调函数的类。其作用是给回调函数套上一层Fiber的壳。该类只用于EventManger内部。
### 属性
#### name \[R\]
事件名，只读。
#### info \[R\]
事件被触发时所包含的信息(调用EventManger#trigger方法时传入的info参数)，只读。
#### callback \[R\]
回调函数，只读。
### 实例方法
#### new(event_manger, name, callback, info)
创建一个EventCallbackFiber的实例对象。
`event_manger`:对应的EventManger对象。
`name`:事件名。
`callback`:欲包裹的事件回调，为一个proc对象。
`info`:事件被触发时所包含的信息。
#### resume
事件挂起后，调用此方法返回到挂起前的地方。等同于`Fiber#resume`。
#### alive？
判断该对象对应的Fiber实例是否存活，若存活返回true。

## Event::Event
该类只用于EventManger内部,是Array的子类。其实质是一个event事件回调Proc的数组。
### 属性
#### name \[R\]
事件名，只读。
#### type \[R\]
事件类型，只读。
### 实例方法
#### new(name, type)
创建一个event对象实例。
`name`:事件名。
`type`:事件类型。