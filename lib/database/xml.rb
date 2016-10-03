#encoding: utf-8
#author: shitake
#data: 16-8-24

module XML

  class Node

    attr_accessor :name
    attr_accessor :attr
    attr_accessor :parent
    attr_accessor :child
    attr_accessor :value
    def initialize(name, attr, child = {})
      @name = name
      @attr = attr
      @value = ''
      @parent = nil
      @child = child
    end

    def add_attr(name, val)
      @attr.include?(name) ? (raise "The attribute #{name} already exists!") : @attr[name] = val
    end

    def add_child(val)
      val.parent = self
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

  class PI

  end

  class DTD

  end

  class CDATA

  end

  XMLSyntaxError = Class.new(StandardError)

  class Parser

    def initialize(code)
      @code = code
      @pos = 0
      @root = nil
      @start = false
      @status = nil #0 node_head,1 node_body,2 node_footer
    end

    def error(msg)
      u_text = @code[0, @pos]
      lines = u_text.count("\n") + 1
      cols = u_text[/(.*\n)*/].size
      raise XMLSyntaxError, "XMLParser:line #{lines},clo #{cols}, #{msg}"
    end

    def ch
      @code[@pos]
    end

    def _next(num = 1)
      @pos += num
    end

    def _next?(str)
      pos = @pos
      str.each_char do |char|
        unless ch == char
          @pos = pos
          return false
        end
        _next
      end
      true
    end

    def ws
      @pos += 1 while ch == "\t" || ch == "\n"
    end

    def parse
      node
      @root
    end

    def node
      ws
      if _next?('<')
        if _next?('!DOCTYPE')
          dtd
        elsif _next?('![CDATA[')
          c_data
        elsif _next?('!--')
          annotation
        elsif _next?('?')
          pi
        elsif _next?('/')
          error('') if @status != 1
          @status = 2
          @node = @node.parent
        else
          error("") if @status != 2
          @status = 0
          node = Node.new(name, attr)
          @node.add_child(node)
          @node = node
          @status = 1
          parse
        end
      else
        error("未预期字符(#{ch})!") if @status != 1
        string
      end

    end

    def annotation
      ws
      @pos = @code.index('--', @pos) + 2
      error('') unless _next?('>')
      node
    end

    def c_data
      ws
      error('') if @code.index('<![CDATA[')
      pos = @pos
      @pos = @code.index(']]>', @pos) + 3
      cdata = CDATA.new('CDATA')
      cdata.value = @code[pos, @pos - pos]
      @root.add_child(cdata)
      node
    end

    def dtd
      ws
    end

    def pi
      ws
      error('')
      name_str = name
      if name_str == 'xml'
        error("") if @root
      end
      pos = @pos
      @pos = @code.index('?>', @pos) +
      @root.child.push(pi)
      node
    end

    def name(chr = ' ')
      ws
      error('') unless ch =~ /[a-zA-Z]/
      string(chr)
    end

    def attr
      atr = {}
      ws
      while ch =~ /[a-zA-Z]/
        key = name('=')
        _next
        val = value
        atr[key.to_sym] = val
        ws
      end
      atr
    end

    def value
      error('') if ch != '"'
      string('"')
    end

    def string(chr = '<')
      str = ''
      str += ch until _next?(chr)
      str
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
