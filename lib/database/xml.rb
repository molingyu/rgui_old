require 'pp'

class Parser

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
  end

  def initialize(code, conf = {})
    @node_style = conf[:node_style]
    @attr_style = conf[:attr_style]
    @end_node = conf[:end_node]
    @nodes = conf[:nodes]
    @root = Node.new('root', {}, code)
    parse(@root)
  end

  def root
    @root
  end

  def parse(node)
    return if @end_node.include?(node.name)
    node.child = parse_node(node.child, [])
    node.child.each do |n|
      parse(n)
    end
  end

  def parse_node(code, child)
    return child unless code
    code.strip!
    str = ''
    if @node_style.class == Array
      @node_style.each do |s|
        str = code[s]
        break if str
      end
    else
      str = code[@node_style]
    end
    unless str || (@nodes ? !@nodes.include?($1) : false)
      if child[-1] && child[-1].name == 'text'
        child[-1].value += code
      elsif code != ''
        new_node = Node.new('text', {})
        new_node.value = code
        child.push(new_node)
      end
      return child
    end
    new_node = Node.new($1, parse_attr($2, {}), $3)
    index = code.index(str) + str.length
    code = code[index, code.length - index]
    child.push(new_node)
    parse_node(code, child)
  end

  def parse_attr(code ,attr)
    return {} unless code
    str = ''
    if @attr_style.class == Array
      @attr_style.each do |s|
        str = code[s]
        break if str
      end
    else
      str = code[@attr_style]
    end
    return attr unless str
    index = code.index(str) + str.length
    code = code[index, code.length - index]
    attr[$1.to_sym] = $2
    parse_attr(code, attr)
  end

end


xcode = {
    :node_style => /\[([a-zA-z0-9]*)( [a-zA-z0-9]*=\".*\")*\](.*)\[\/\1\]/,
    :attr_style => /([a-zA-Z0-9]*)=\"([^\"]*)\"/,
    :end_node => ['text'],
    :nodes => nil
}

# ====================================================================================

module XML
  class <<self
    def read(path)
      open(path,'r') do |f|
        return xml = f.read
      end
    end

    def xml2node(path)
      code = path#read(path)
      xml = {
          :node_style => [/<([a-zA-Z]+[^<^ ]*)([^<]*)>(.*)<\/\1>/, /<([a-zA-Z]+[^<^ ]*)([^<]*)\/>/],#|<([a-zA-z0-9]*)( [a-zA-z0-9]*=\".*\")*[ ]*\/>/,#[/<([a-zA-z0-9]*)( [a-zA-z0-9]*=\".*\")*>(.*)<\/\1>/, /<([a-zA-z0-9]*)( [a-zA-z0-9]*=\".*\")*[ ]*\/>/],
          :attr_style => /[ ]*([a-zA-Z]+[^=]*)="([^"]*)"/,
          :end_node => ['text'],
          :nodes => nil
      }
      Parser.new(code, xml)
    end

  end
end

xml = '<s:button><pos x="12" y="23">xssss<type s="23232"/></pos></s:button>'


XML.xml2node(xml).root.child.each{|n| pp n}