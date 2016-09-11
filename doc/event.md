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
``callback``:欲包裹的事件回调，为一个proc对象。
``info``:事件被触发时所包含的信息。

#### resume
事件挂起后，调用此方法返回到挂起前的地方。等同于``Fiber#resume``。

#### alive？
判断该对象对应的Fiber实例是否存活，若存活返回true。


## Event::Event
此类用于EventManger内部,是Array的子类。其实质是一个event事件回调函数的数组。

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