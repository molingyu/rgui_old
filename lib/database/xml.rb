#encoding: utf-8
#author: shitake
#data: 16-8-24

module XML

  class Node

    attr_accessor :name
    attr_accessor :attr
    attr_accessor :child
    attr_accessor :value
    def initialize(name, attr, child = {})
      @name = name
      @attr = attr
      @value = ''
      @child = child
    end

    def add_attr(name, val)
      @attr.include?(name) ? (raise "The attribute #{name} already exists!") : @attr[name] = val
    end

    def add_child(val)
      @child.push(val)
    end

    def to_s
      body = ''
      @child.each { |node| body += node.to_s }
      if body == ''
        "<#{@name}#{attr2s}/>"
      else
        "<#{@name}#{attr2s}>#{body}</#{@name}>"
      end
    end

    def attr2s
      str = ''
      @attr.each_with_index { |key, value| str += " #{key}=\"#{value}\"" }
      str
    end

  end

  XMLSyntaxError = Class.new(StandardError)

  class Parser

    def initialize(code)
      @code = code
      @pos = 0
    end

    def error(msg)
      u_text = @code[0, @pos]
      lines = u_text.count("\n") + 1
      cols = u_text[/(.*\n)*/].size
      raise XMLSyntaxError, "XMLParser:第#{lines}行,第#{cols}字符处, #{msg}"
    end

    def ch
      @code[@pos]
    end

    def ws
      @pos += 1 while ch == "\t" || ch == "\n"
    end

    def is_name?(str)
      error('XML 元素名称不能以数字或者标点符号开始！') unless str[0] =~ /[a-zA-z]/
      error('XML 元素名称不能以字符 “xml”（或者 XML、Xml）开始！') if str[0, 3] == 'XML' || str[0, 3] == 'xml' || str[0, 3] == 'Xml'
    end

    def parse

    end

    def node_head

    end

    def node_body

    end

  end

  class <<self
    def xml2node(str)
      Parser.new(str).parse
    end
  end
end

module Kernel
  def xml(value)
    XML.xml2node(value)
  end
end
