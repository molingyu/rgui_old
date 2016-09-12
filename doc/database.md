# Database
RM数据模块，用于xml/csv/json的读取。

## XML
### 模块方法
#### xml2node(str)
将字符串转换为XNode对象。

`str`:欲转换的字符串。
## JSON
### 模块方法
#### json2hash(str)
将字符串转换为Hash对象。

`str`:欲转换的字符串。
## CSV
### 模块方法
#### csv2object(str， template)
将字符串转换为csv对象。

`str`:欲转换的字符串。
## 关于`Kernel`模块的公共方法
XML/JSON/CSV三个都有对应的定义在Kernel模块的函数:xml(value)/json(value)/csv(value)。相当于每个模块的读取函数的简便写法。